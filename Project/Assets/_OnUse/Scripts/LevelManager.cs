using System.Collections;
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
        for (int i = 0; i < totalLevels; i++)
        {
            levelScores[i] = -1;
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
        levelScores[level - 1] = score;
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
