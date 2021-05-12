﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Goal : MonoBehaviour
{

   

    [SerializeField] private float timeToWinStart;
    public delegate void Win();
    public Win OnWin;

    private float timeToWin;


    private void Start()
    {
        ResetTimer();
        GameManager.instance.GoalReference(this);
    }

    private void ResetTimer()
    {
        timeToWin = timeToWinStart;
    }


    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            timeToWin -= Time.deltaTime;

            if (timeToWin <= 0)
            {
                TriggerWin();
            }
        }    
    }

    private void TriggerWin()
    {
        print("You win!!");
        OnWin?.Invoke();
    }


    private void OnTriggerExit(Collider other)
    {
        ResetTimer();
    }




}
