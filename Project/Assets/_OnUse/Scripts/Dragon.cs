using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dragon : MonoBehaviour
{

    [SerializeField] private Transform[] dragonPatrolPoints;
    private int nextWaypoint;
    private int waypointModifier = 1;
    [SerializeField] private float distance = 0.1f;
    [SerializeField] private float flySpeed = 10f;
    private Rigidbody rb;

    [Range(2, 10)] [SerializeField] private float timerToBreathMin,timerToBreathMax;
    private float timerToBreath;

    [SerializeField] private ParticleSystem[] partSystems;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        ResetTimer();
    }

    private void ResetTimer()
    {
        timerToBreath = Random.Range(timerToBreathMin, timerToBreathMax);
    }

    private void FixedUpdate()
    {
        CheckpointUpdate();
        timerToBreath -= Time.deltaTime;

        if ( timerToBreath <= 0)
        {
            BreathFire();
            ResetTimer();
        }

    }

    private void BreathFire()
    {
        for (int i = 0; i < partSystems.Length; i++)
        {
            partSystems[i].Play();
        }
    }

    private void CheckpointUpdate()
    {
        var nextPoint = dragonPatrolPoints[nextWaypoint];
        var nextPointPosition = nextPoint.position;
        var nextPointDirection = nextPointPosition - transform.position;
        if (nextPointDirection.magnitude < distance)
        {
            if (nextWaypoint + waypointModifier >= dragonPatrolPoints.Length || nextWaypoint + waypointModifier < 0)
            {
                nextWaypoint = -1;
            }

            nextWaypoint += waypointModifier;
        }

        Move(nextPointDirection.normalized, flySpeed);
    }

    private void Move(Vector3 dir, float speed)
    {
        transform.forward = Vector3.Lerp(transform.forward, dir, 0.06f);
        var newVelocity = transform.forward * speed + new Vector3(0, rb.velocity.y, 0);
        rb.velocity = newVelocity;
    }
}
