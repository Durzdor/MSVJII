using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BackToMenuScene : MonoBehaviour
{
   
    public void LoadScene ( string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }


}
