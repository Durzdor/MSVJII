using UnityEngine;
using System.Collections;
 
[AddComponentMenu("Camera-Control/Mouse Orbit with zoom")]
public class Camera2 : MonoBehaviour {

    [SerializeField] private Transform target;
    [SerializeField] private float distance = 5.0f;
    [SerializeField] private float xSpeed = 120.0f;
    [SerializeField] private float ySpeed = 120.0f;

    [SerializeField] private float yMinLimit = -20f;
    [SerializeField] private float yMaxLimit = 80f;

    [SerializeField] private float distanceMin = .5f;
    [SerializeField] private float distanceMax = 15f;

    [SerializeField] private GameObject aerealCamera;
 
    private Rigidbody _rb;
    private Vector3 _cameraOffset;
    [Tooltip("The smooth factor when the camera follows a target object")]
    [Range(0.2f, 1f)]
    public float cameraFollowSmoothness;
 
    float x = 0.0f;
    float y = 0.0f;
 
    // Use this for initialization
    void Start () 
    {
        target = FindObjectOfType<Ball>().GetComponent<Transform>();
        _cameraOffset = transform.position - target.position;

        Vector3 angles = transform.eulerAngles;
        x = angles.y;
        y = angles.x;
 
        _rb = GetComponent<Rigidbody>();
 
        // Make the rigid body not change rotation
        if (_rb != null)
        {
            _rb.freezeRotation = true;
        }
    }

    private void Update()
    {
        if (GameManager.instance.isPaused) return;
        CheckChangeToAerealCamera();
    }

    void LateUpdate () 
    {
        if (GameManager.instance.isPaused) return;

        // If target
        if (Input.GetMouseButton(1)) 
        {
            x += Input.GetAxis("Mouse X") * xSpeed * distance * 0.02f;
            y -= Input.GetAxis("Mouse Y") * ySpeed * 0.02f;
 
            y = ClampAngle(y, yMinLimit, yMaxLimit);
 
            Quaternion rotation = Quaternion.Euler(y, x, 0);
 
            distance = Mathf.Clamp(distance - Input.GetAxis("Mouse ScrollWheel")*5, distanceMin, distanceMax);
 
            
            RaycastHit hit;
            if (Physics.Linecast (target.position, transform.position, out hit)) 
            {
                distance -=  hit.distance;
            }
            Vector3 negDistance = new Vector3(0.0f, 0.0f, -distance);
            Vector3 position = rotation * negDistance + target.position;
 
            transform.rotation = rotation;
            transform.position = position;
            _cameraOffset = transform.position - target.position;
        }

        if (!Input.GetMouseButton(1))
        {
            FollowTarget();
            transform.LookAt(target);
        }
    }

    private void CheckChangeToAerealCamera()
    {
        // if (Input.GetKeyDown(KeyCode.LeftShift))
        // {
        //     aerealCamera.SetActive(true);
        // }
        //
        // if (Input.GetKeyUp(KeyCode.LeftShift))
        // {
        //     aerealCamera.SetActive(false);
        // }
    }
    public static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360F)
            angle += 360F;
        if (angle > 360F)
            angle -= 360F;
        return Mathf.Clamp(angle, min, max);
    }

    private void FollowTarget()
    {
        var newPosition = target.position + _cameraOffset;
        transform.position = Vector3.Slerp(transform.position, newPosition, cameraFollowSmoothness);
    }
}