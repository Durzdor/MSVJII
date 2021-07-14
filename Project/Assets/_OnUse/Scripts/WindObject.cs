using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindObject : MonoBehaviour
{

    public Vector3 WindDirection
    {
        get
        {
            return windDirectionTester;
        }
        set
        {
            WindDirection = value;
        }
    }

    private bool isBlowing;

    [SerializeField] private float timeToStopBlowing;
    [SerializeField] private float timeToStartBlowing;
    private float _timeToStartBlowing;
    private float _timeToStopBlowing;

    [SerializeField] private ParticleSystem particleSys1;
    [SerializeField] private ParticleSystem particleSys2;
    public float WindForce => windForce;

    [SerializeField] private float windForceToUpDirection;

    [SerializeField] private Vector3 windDirectionTester;
    [SerializeField] private float windForce;
    private BoxCollider windCollider;

    private void Start()
    {
        windCollider = GetComponent<BoxCollider>();
        _timeToStopBlowing = timeToStopBlowing;
        _timeToStartBlowing = timeToStartBlowing;
    }

    private void Update()
    {
        //While blowing

        if (isBlowing)
        {
            _timeToStopBlowing -= Time.deltaTime;

            if (_timeToStopBlowing <= 0)
            {
                _timeToStopBlowing = timeToStopBlowing;
                StartBlowing(false);
            }
            return;
        }


        //Until it starts to blow
        _timeToStartBlowing -= Time.deltaTime;

        if (_timeToStartBlowing <= 0)
        {
            _timeToStartBlowing = timeToStartBlowing;
            StartBlowing(true);            
        }        
    }






    public void StartBlowing(bool newState)
    {
        //Change windCollider state. If active => inactive, if inactive => active
        isBlowing = newState;
        windCollider.enabled = newState;

        //Activate or deactive wind particles

        if (newState == true)
        {
            particleSys1.Play();
            particleSys2.Play();

        }
        else
        {
            particleSys1.Stop();
            particleSys2.Stop();
            
        }

      
    }



    //Wind from XZ plane
    private void OnTriggerStay(Collider other)
    {
        other.attachedRigidbody.AddForce(WindDirection.x * transform.right * windForce + WindDirection.z * transform.forward * windForce, ForceMode.Force);
    }


    //Separate impulse code
    private void OnTriggerEnter(Collider other)
    {
        other.attachedRigidbody.AddForce(WindDirection.y * Vector3.up * windForceToUpDirection, ForceMode.Impulse);
    }
}
