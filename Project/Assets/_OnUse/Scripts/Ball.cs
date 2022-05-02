using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    private Rigidbody rb;

    private Vector3 lastKnownGoodPosition;
    [SerializeField] private int timesToDissapearBall;
    [SerializeField] private float timeToResetPosition;
    private Vector3 originalScale;
    private CameraTransitionManager camTransManager;
    [SerializeField] private float reappearGroundOffset;
    [Range(0, 1)] [SerializeField] private float shrinkerValue;

    private Vector3 lastFrameVelocity;
    [SerializeField] private float minVelocity;

    [SerializeField] private Vector2 dragRange = new Vector2(0.3f, 1f);
    [SerializeField] private float minVelocityToDrag = 0.1f;
    private float groundCheckDistance = 0.01f;
    [SerializeField] private float airDragValue = 0.3f;
    public float InitialForce { get; set; }
    public bool IsGrounded => Physics.Raycast(transform.position, -Vector3.up, groundCheckDistance + 0.1f);

    private bool dissapearing;

    public bool Dissapearing
    {
        get { return dissapearing; }
        private set
        {
            dissapearing = value;
            Debug.Log("Disappear");
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        originalScale = transform.localScale;
        GameObject ballStartPos = GameObject.FindGameObjectWithTag("BallStartPosition");
        transform.position = ballStartPos.transform.position;
        Destroy(ballStartPos);
        rb = GetComponent<Rigidbody>();
        rb.sleepThreshold = 0.5f;
        rb.maxAngularVelocity = Mathf.Infinity;
        camTransManager = FindObjectOfType<CameraTransitionManager>();
        SetKnownGoodPosition(transform.position);
        groundCheckDistance = GetComponent<SphereCollider>().bounds.extents.y;
    }

    public void SetKnownGoodPosition(Vector3 pos)
    {
        lastKnownGoodPosition = pos;
        //camTransManager.ChangeLastKnownGoodCamera();
    }

    public void ToKnownGoodPosition()
    {
        Dissapearing = true;
        StartCoroutine(GoToKnownGoodPosition());
    }

    private IEnumerator GoToKnownGoodPosition()
    {
        for (int i = 0; i < timesToDissapearBall; i++)
        {
            transform.localScale *= shrinkerValue;
            yield return new WaitForSecondsRealtime(timeToResetPosition);
        }

        ResetVelocities();
        transform.position = lastKnownGoodPosition + Vector3.up * reappearGroundOffset;
        transform.localScale = originalScale;
        //camTransManager.ToLastKnownGoodCamera();
        Dissapearing = false;
    }

    private void FixedUpdate()
    {
        lastFrameVelocity = rb.velocity;
        if (IsGrounded && rb.velocity.magnitude > minVelocityToDrag)
        {
            GroundDrag();
        }

        if (!IsGrounded)
        {
            AirDrag();
        }

        if (transform.position.y <= -7f)
        {
            transform.position = new Vector3(transform.position.x, -7f, transform.position.z);
            SlowFall();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Wall"))
        {
            Bounce(collision.contacts[0].normal);
        }
    }

    private void Bounce(Vector3 collisionNormal)
    {
        var speed = lastFrameVelocity.magnitude;
        var direction = Vector3.Reflect(lastFrameVelocity.normalized, collisionNormal);
        rb.velocity = direction * Mathf.Max(speed, minVelocity);
    }

    private void ResetVelocities()
    {
        rb.useGravity = true;
        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
    }

    private void GroundDrag()
    {
        var t = Mathf.InverseLerp(rb.sleepThreshold, InitialForce, rb.velocity.magnitude);
        var currentDrag = Mathf.Lerp(dragRange.x, dragRange.y, 1 - t);
        rb.velocity -= (currentDrag * Time.fixedDeltaTime) * rb.velocity;
    }

    private void AirDrag()
    {
        rb.velocity -= (airDragValue * Time.fixedDeltaTime) * rb.velocity;
    }

    private void SlowFall()
    {
        rb.useGravity = false;
        var newVel = new Vector3(rb.velocity.x, 0, rb.velocity.z);
        rb.velocity = newVel;
    }
}