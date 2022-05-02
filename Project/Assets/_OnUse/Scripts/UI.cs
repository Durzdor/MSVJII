using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UI : MonoBehaviour
{
    [SerializeField] private Image fillImage;
    [SerializeField] private GameObject canvasFillImageObject;
    [SerializeField] private Text strokesCount;
    [SerializeField] private Text golfClubEquippedName;
    [SerializeField] private Image golfClubEquippedImage;
    [SerializeField] private GameObject golfClub;
    [SerializeField] private GameObject scoreSheet;
    private AudioSource scoreSheetAudioSrc;

    [SerializeField] private TextMeshProUGUI [] levelScoresText;

    private void Start()
    {
        scoreSheetAudioSrc = scoreSheet.GetComponent<AudioSource>();
        GameManager.instance.UIReferenceAssign(this);
        UpdateScores();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            EnableDisableScoreSheet(!scoreSheet.activeSelf);
        }

        if (Input.GetKeyDown(KeyCode.I))
        {
            Debug.LogError($"level score length {levelScoresText.Length}");
            for (int i = 0; i < levelScoresText.Length; i++)
            {
                Debug.Log($"level {i + 1} score is {levelScoresText[i].text}");
            }
        }
    }

    public void ChangeFillImageFill(float newFill)
    {
        fillImage.fillAmount = newFill;
    }

    public void EnableDisableFillImage (bool newState)
    {
        canvasFillImageObject.SetActive(newState);
    }

    public void EnableDisableScoreSheet(bool newState)
    {
        scoreSheet.SetActive(newState);

        if (newState) GameManager.instance.Pause();
        else GameManager.instance.Unpause();        

        if (newState) scoreSheetAudioSrc.Play();
    }
   
    public void EnableDisableGolfClub(bool newState)
    {
        golfClub.SetActive(newState);
    }
    public void UpdateStrokes (int newStrokes)
    {
        strokesCount.text = newStrokes.ToString();
    }

    public void UpdateGolfClub (Sprite newGolfClubImage, string newGolfClubName)
    {
        golfClubEquippedName.text = newGolfClubName;
        golfClubEquippedImage.sprite = newGolfClubImage;
    }

    public void UpdateScores()
    {
        int[] scores = GameManager.instance.lvlManager.RecallScores();    
    

        for (int i = 0; i < levelScoresText.Length; i++)
        {
         
            if (scores[i] < 0) levelScoresText[i].text = "";           
            else levelScoresText[i].text = scores[i].ToString();
          
        }
    }
}
