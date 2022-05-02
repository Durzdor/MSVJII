using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New golf club", menuName = "propietaryAssets/GolfClub", order = 0)]
public class GolfClub1 : ScriptableObject
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
