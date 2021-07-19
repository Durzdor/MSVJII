using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pendulum : MonoBehaviour
{

    [SerializeField] float MaxAngleDeflection;
    [SerializeField] float SpeedOfPendulum;
    [SerializeField] float deformationAmount;
    private Quaternion mainRotation;
    private Vector3 secondaryRotation;
    public enum Pivot
    {
        X,
        Y,
        Z
    }

    public Pivot pivotingAxis;

    private void FixedUpdate()
    {
        float angle = MaxAngleDeflection * Mathf.Sin(Time.time * SpeedOfPendulum);
        float deformatedAngle = MaxAngleDeflection * Mathf.Sin(Time.time * SpeedOfPendulum + deformationAmount);
        float deformation = deformatedAngle * Time.deltaTime * deformationAmount;
        switch (pivotingAxis)
        {
            case Pivot.X:
                mainRotation = Quaternion.Euler(angle, 0, 0);
                secondaryRotation = new Vector3(0, deformation, deformation);
                break;
            case Pivot.Y:
                mainRotation = Quaternion.Euler(0, angle, 0);
                secondaryRotation = new Vector3(deformation, 0, deformation);
                break;
            case Pivot.Z:
                mainRotation = Quaternion.Euler(0, 0, angle);
                secondaryRotation = new Vector3(deformation, deformation, 0);
                break;
            default:
                break;
        }

        transform.localRotation = mainRotation;
        transform.Rotate(secondaryRotation);



    }
  



}
