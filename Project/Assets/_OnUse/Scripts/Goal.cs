using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Goal : MonoBehaviour
{
    [SerializeField] private bool isFloatingGoal;
    [SerializeField] private float timeToWinStart;

    public delegate void Win();

    public Win OnWin;
    private SphereCollider sphereColl;
    private AudioSource winMusic;
    public bool audioIsPlaying => winMusic.isPlaying;
    private float timeToWin;

    [SerializeField] private ParticleSystem[] partSys;

    private void Start()
    {
        winMusic = GetComponent<AudioSource>();
        ResetTimer();
        sphereColl = GetComponent<SphereCollider>();
        GameManager.instance.GoalReference(this);
        winMusic = GetComponent<AudioSource>();
    }

    private void ResetTimer()
    {
        timeToWin = timeToWinStart;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!isFloatingGoal) return;
        if (other.CompareTag("Player"))
        {
            TriggerWin();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            //winMusic.Play();
            timeToWin -= Time.deltaTime;

            if (timeToWin <= 0)
            {
                StartCoroutine(ToWin());               
             
            }
        }
    }

    private IEnumerator ToWin()
    {
        GameObject go = GameObject.FindGameObjectWithTag("BackgroundMusi");

        go.GetComponent<AudioSource>().Stop();
        sphereColl.enabled = false;
        winMusic.Play();
        if (partSys.Length > 0)
        {
            for (int i = 0; i < partSys.Length; i++)
            {
                partSys[i].Play();
            }
        }
       

        while (winMusic.isPlaying)
        {
            yield return new WaitForSecondsRealtime(0.2f);
        }

     

        OnWin?.Invoke();
    }
    private void TriggerWin()
    {
        sphereColl.enabled = false;
        OnWin?.Invoke();
    }

    private void OnTriggerExit(Collider other)
    {
        ResetTimer();
    }
}