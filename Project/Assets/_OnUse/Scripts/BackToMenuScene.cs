using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class BackToMenuScene : MonoBehaviour
{
    private Button mainMenuButton;
    [SerializeField] private TextMeshProUGUI[] scoreTexts;
    private int[] lvlScores;

    private void Start()
    {
        mainMenuButton = GetComponent<Button>();
        mainMenuButton.onClick.AddListener(ButtonPress);
        lvlScores = GameManager.instance.lvlManager.LevelScores;
        ScoreDisplay();
    }

    public void ButtonPress()
    {
        GameManager.instance.LoadScene("MainMenu");
    }

    public void ScoreDisplay()
    {
        for (int i = 0; i < lvlScores.Length; i++)
        {
            if (i >= lvlScores.Length) break;
            if (lvlScores[i] < 0)
            {
                scoreTexts[i].text = "";
                continue;
            }
            scoreTexts[i].text = lvlScores[i].ToString();
        }
    }
}