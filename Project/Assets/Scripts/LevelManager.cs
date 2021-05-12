﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager: MonoBehaviour
{

    [SerializeField] private int currentLevel;
    [SerializeField] private int totalLevels;
    [SerializeField] private string[] levelNames;
    private int[] levelScores;

    public delegate void NextLevel(string levelToLoad);
    public NextLevel OnNextLevel;


    private void Start()
    {
        levelScores = new int[totalLevels];
    }

    public void ToNextLevel()
    {
        currentLevel++;
        if (currentLevel > totalLevels) currentLevel = 0;
        StartALevel();      
    }
    
    public void StartALevel()
    {
        OnNextLevel?.Invoke(levelNames[currentLevel]);
    }


    public void SetScoreForLevel(int level, int score)
    {
      
        levelScores[level - 1] = score;

        print($"Score for level {level} was {score}");
        print("Pos 0 is " + levelScores[0]);
    }

    public int[] RecallScores()
    {
        return levelScores;
    }

    public void OnWonLevelHandler()
    {     
        SetScoreForLevel(currentLevel, GameManager.instance.strokeManager.StrokeCount);
        ToNextLevel();
    }




}
