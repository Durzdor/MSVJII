using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager: MonoBehaviour
{

    [SerializeField] private int currentLevel;
    [SerializeField] private string[] levelNames;
    private int[] levelScores;

    public delegate void NextLevel(string levelToLoad);
    public NextLevel OnNextLevel;
    private UI ui;

    public int[] LevelScores => levelScores;

    private void Awake()
    {
        levelScores = new int[levelNames.Length];
        ResetScores();
    }
    
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            OnWonLevelHandler();
        }
    }

    public void ToNextLevel()
    {
        currentLevel++;
        if (currentLevel > levelNames.Length - 1)
        {
            currentLevel = 0; 
            GameManager.instance.LoadScene("WinScene");
            return;
        }
        StartALevel();      
    }
    
    public void StartALevel()
    {
        OnNextLevel?.Invoke(levelNames[currentLevel]);
    }


    public void SetScoreForLevel(int level, int score)
    {
        levelScores[level] = score;
    }

    public int[] RecallScores()
    {
        return levelScores;
    }

    public void OnWonLevelHandler()
    {     
        SetScoreForLevel(currentLevel, GameManager.instance.strokeManager.StrokeCount);
        GameManager.instance.uiReference.UpdateScores();
        ToNextLevel();
    }

    public void ResetScores()
    {
        for (int i = 0; i < levelNames.Length; i++)
        {
            levelScores[i] = -1;
        }
    }
}