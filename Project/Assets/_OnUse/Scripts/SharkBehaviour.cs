using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class SharkBehaviour : MonoBehaviour
{
    [SerializeField] private Transform[] sharkPatrolPoints;
    [SerializeField] private float distance = 0.1f;
    [SerializeField] private float swimSpeed = 10f;
    [SerializeField] private float heightCheck = -0.5f;
    [SerializeField] private float timeToCheckBite = 2.5f;
    private float timeToCheckMax;
    private int nextWaypoint;
    private int waypointModifier = 1;
    private Rigidbody rb;
    private Animator anim;
    private Ball ball;
    private Camera2 cam;
    [SerializeField] private Camera camMain;

    private bool IsGoingToBite => ball.transform.position.y / 3 <= heightCheck;
    private bool isBiting;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        ball = FindObjectOfType<Ball>();
        anim = GetComponent<Animator>();
        timeToCheckMax = timeToCheckBite;
        cam = camMain.GetComponent<Camera2>();
    }

    private void FixedUpdate()
    {
        timeToCheckBite -= Time.fixedDeltaTime;
        if (!IsGoingToBite)
        {
            cam.enabled = true;
            CheckpointUpdate();
        }

        if (IsGoingToBite)
        {
            if (timeToCheckBite <= 0)
            {
                anim.SetBool("Tracking", true);
                SharkCam();
                BiteBall();
            }
        }
    }

    private void CheckpointUpdate()
    {
        var nextPoint = sharkPatrolPoints[nextWaypoint];
        var nextPointPosition = nextPoint.position;
        var nextPointDirection = nextPoint.position - transform.position;
        if (nextPointDirection.magnitude < distance)
        {
            if (nextWaypoint + waypointModifier >= sharkPatrolPoints.Length || nextWaypoint + waypointModifier < 0)
            {
                nextWaypoint = -1;
            }

            nextWaypoint += waypointModifier;
        }

        Move(nextPointDirection.normalized, swimSpeed);
    }

    private void Move(Vector3 dir, float speed)
    {
        transform.forward = Vector3.Lerp(transform.forward, dir, 0.06f);
        var newVelocity = transform.forward * speed + new Vector3(0, rb.velocity.y, 0);
        rb.velocity = newVelocity;
    }

    private void BiteBall()
    {
        var dirToBall = ball.transform.position - transform.position;
        dirToBall.y = 0;
        Move(dirToBall.normalized, swimSpeed * 2);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            anim.SetBool("Tracking", false);
            anim.SetTrigger("Biting");
            timeToCheckBite = timeToCheckMax;
            if (ball.Dissapearing) return;
            ball.ToKnownGoodPosition();
        }
    }

    private void SharkCam()
    {
        cam.enabled = false;
        camMain.transform.position = ball.transform.position;
        camMain.transform.LookAt(transform.position);
    }
}