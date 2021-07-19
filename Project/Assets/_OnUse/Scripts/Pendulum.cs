using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pendulum : MonoBehaviour
{

    [SerializeField] float MaxAngleDeflection;
    [SerializeField] float SpeedOfPendulum;
    [SerializeField] float deformationAmount;

    private void FixedUpdate()
    {
        float angle = MaxAngleDeflection * Mathf.Sin(Time.time * SpeedOfPendulum);
        transform.localRotation = Quaternion.Euler(angle, 0, 0);

        float deformatedAngle = MaxAngleDeflection * Mathf.Sin(Time.time * SpeedOfPendulum + deformationAmount);
        transform.Rotate(new Vector3(0, deformatedAngle * Time.deltaTime * deformationAmount, deformatedAngle * Time.deltaTime * deformationAmount));
    }
  



}
