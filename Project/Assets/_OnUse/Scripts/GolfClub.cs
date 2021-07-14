using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GolfClub : MonoBehaviour
{

    [SerializeField] private float generalStrength;
    [SerializeField] private float verticalFactorStrength;
    [Range(0, 1)] [SerializeField] private float shotUncontroll;
    [SerializeField] private Sprite clubSprite;
    [SerializeField] private string clubName;
    public AudioClip hitSound;

    public float GeneralStrength => generalStrength;
    public float VerticalFactorStrength => verticalFactorStrength;
    public float ShotUncontroll => shotUncontroll;
    public Sprite ClubSprite => clubSprite;
    public string ClubName => clubName;
}
