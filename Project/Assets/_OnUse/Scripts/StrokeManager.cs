using System;
using UnityEngine;

public class StrokeManager : MonoBehaviour
{
    public enum StartingAngle
    {
        ZForward = 0,
        XForward = 90,
        ZBackward = 180,
        XBackward = 270
    };

    [Tooltip("A que direccion apunta al principio")]
    public StartingAngle startingAngle;

    public StrokeState StrokeMode { get; protected set; }

    public delegate void MaxStrokesReached();

    public MaxStrokesReached OnMaxStrokesReached;
    [SerializeField] private int maxStrokes;
    [SerializeField] private float uiArrowYOffset;
    private GameObject ballGO;
    private Ball ball;
    private Rigidbody playerBallRB;
    [SerializeField] private AudioSource audioSrc;
    private float strokeAngle;
    [SerializeField] private GameObject hitArrow;

    public float StrokeAngle
    {
        get { return strokeAngle; }
        protected set
        {
            strokeAngle = value;
            hitArrow.transform.rotation = Quaternion.Euler(0, strokeAngle + 180, 0);
            //ui.ChangeArrowAngle(strokeAngle,Camera.main.transform.rotation.eulerAngles.y);
        }
    }

    public float StrokeForce { get; protected set; }

    public float StrokeForcePerc
    {
        get { return StrokeForce / (MaxStrokeForce * currentGolfClub.GeneralStrength); }
    }

    public int StrokeCount { get; protected set; }

    [SerializeField] private float angleChangeSpeed = 100;
    private float strokeForceFillSpeed = 5f;
    [SerializeField] private float strikeFillSpeed;
    [SerializeField] float MaxStrokeForce = 10f;
    private UI ui;
    [SerializeField] private GolfClub[] golfClubsAvailable;
    private GolfClub currentGolfClub;

    public enum StrokeState
    {
        Aiming,
        ForceSet,
        Hit,
        Move
    };

    private void FindPlayerBall()
    {
        ballGO = GameObject.FindGameObjectWithTag("Player");
        ball = ballGO.GetComponent<Ball>();
        playerBallRB = ballGO.GetComponent<Rigidbody>();
    }

    private void EnableArrow(bool isEnabled)
    {
        hitArrow.SetActive(isEnabled);
        hitArrow.transform.position = playerBallRB.transform.position + new Vector3(0, uiArrowYOffset, 0);
    }

    private void ChangeState(StrokeState newState)
    {
        StrokeMode = newState;

        switch (StrokeMode)
        {
            case StrokeState.Aiming:
                ui.EnableDisableFillImage(false);
                ui.EnableDisableGolfClub(true);
                EnableArrow(true);
                break;

            case StrokeState.ForceSet:
                ui.EnableDisableFillImage(true);
                break;

            case StrokeState.Hit:
                EnableArrow(false);
                ui.EnableDisableFillImage(false);
                ui.EnableDisableGolfClub(false);
                HitBall();
                break;

            default:
                break;
        }
    }

    private void FindArrow()
    {
        hitArrow = GameObject.FindGameObjectWithTag("3DArrow");
    }

    void Start()
    {
        FindPlayerBall();
        GetUI();
        StrokeCount = 0;
        StrokeAngle = (float) startingAngle;
        ChangeState(StrokeState.Aiming);
        currentGolfClub = golfClubsAvailable[0];
        UpdateGolfClubUI();
        GameManager.instance.StrokeManagerRef(this);
        audioSrc = GetComponent<AudioSource>();
    }

    private void GetUI()
    {
        ui = GameObject.FindGameObjectWithTag("UI").GetComponent<UI>();
    }

    private void UpdateGolfClubUI()
    {
        ui.UpdateGolfClub(currentGolfClub.ClubSprite, currentGolfClub.ClubName);
    }

    private void HitBall()
    {
        Vector3 forceVec = StrokeForce * Vector3.forward +
                           StrokeForce * Vector3.up * currentGolfClub.VerticalFactorStrength;
        playerBallRB.AddForce(Quaternion.Euler(0, StrokeAngle, 0) * forceVec, ForceMode.Impulse);
        ball.InitialForce = forceVec.magnitude;
        StrokeForce = 0;
        StrokeCount++;
        audioSrc.clip = currentGolfClub.hitSound;
        audioSrc.Play();
        ui.UpdateStrokes(StrokeCount);
        ChangeState(StrokeState.Move);
    }

    private void Update()
    {
        if (GameManager.instance.isPaused) return;

        switch (StrokeMode)
        {
            case StrokeState.Aiming:
                if (playerBallRB.velocity.magnitude > 5)
                {
                    ChangeState(StrokeState.Move);
                    EnableArrow(false);
                    return;
                }
                if (StrokeCount >= maxStrokes)
                {
                    OnMaxStrokesReached?.Invoke();
                }

                StrokeAngle += Input.GetAxis("Horizontal") * angleChangeSpeed * Time.deltaTime;

                if (Input.GetKeyDown(KeyCode.Alpha1))
                {
                    currentGolfClub = golfClubsAvailable[0];
                    UpdateGolfClubUI();
                }

                if (Input.GetKeyDown(KeyCode.Alpha2))
                {
                    currentGolfClub = golfClubsAvailable[1];
                    UpdateGolfClubUI();
                }

                if (Input.GetKeyDown(KeyCode.Alpha3))
                {
                    currentGolfClub = golfClubsAvailable[2];
                    UpdateGolfClubUI();
                }

                if (Input.GetButtonUp("Fire1"))
                {
                    ChangeState(StrokeState.ForceSet);
                }

                break;

            case StrokeState.ForceSet:

                StrokeForce += (strokeForceFillSpeed * Input.mouseScrollDelta.y * strikeFillSpeed) * Time.deltaTime *
                               currentGolfClub.GeneralStrength;

                if (StrokeForce > MaxStrokeForce * currentGolfClub.GeneralStrength)
                {
                    StrokeForce = MaxStrokeForce * currentGolfClub.GeneralStrength;
                }
                else if (StrokeForce < 0)
                {
                    StrokeForce = 0;
                }

                ui.ChangeFillImageFill(StrokeForcePerc);

                if (Input.GetMouseButtonDown(1))
                {
                    ChangeState(StrokeState.Aiming);
                }

                if (Input.GetButtonUp("Fire1"))
                {
                    ChangeState(StrokeState.Hit);
                }

                break;
            case StrokeState.Hit:
                break;

            case StrokeState.Move:
                CheckRollingStatus();
                if (Input.GetKeyDown(KeyCode.R))
                {
                    if (ball.Dissapearing) return;
                    ball.ToKnownGoodPosition();
                }

                break;
            default:
                break;
        }
    }

    void CheckRollingStatus()
    {
        if (playerBallRB.IsSleeping())
        {
            if (ball.IsGrounded)
            {
                ball.SetKnownGoodPosition(ball.transform.position);
            }
            ChangeState(StrokeState.Aiming);
        }
    }
}