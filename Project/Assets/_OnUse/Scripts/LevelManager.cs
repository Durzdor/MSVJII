using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager: MonoBehaviour
{

    [SerializeField] private int currentLevel;
    [SerializeField] private int totalLevels;
    [SerializeField] private string[] levelNames;
    private int playableLevels;
    private int[] levelScores;

    public delegate void NextLevel(string levelToLoad);
    public NextLevel OnNextLevel;
    private UI ui;

    public int[] LevelScores => levelScores;

    private void Awake()
    {
        // Restar la cantidad de niveles que no son jugables (MainMenu,WinScene)
        playableLevels = totalLevels - 2;
        levelScores = new int[playableLevels];
        for (int i = 0; i < playableLevels; i++)
        {
            LevelScores[i] = -1;
        }
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
        LevelScores[level - 1] = score;
    }

    public int[] RecallScores()
    {
        return LevelScores;
    }

    public void OnWonLevelHandler()
    {     
        SetScoreForLevel(currentLevel, GameManager.instance.strokeManager.StrokeCount);
        GameManager.instance.uiReference.UpdateScores();
        ToNextLevel();
    }




}