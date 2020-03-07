using UnityEngine;
using UnityEngine.UI;

public class PlayerScore : MonoBehaviour
{
    public Text waterText = null;
    public Text animalText = null;
    public Text fishText = null;
    public Text birdText = null;
    public Text cloudText = null;
    public Text humanText = null;
    public Text plantText = null;

    private int _waterLevel = 0;
    private int _animalCount = 0;
    private int _birdCount = 0;
    private int _fishCount = 0;
    private int _cloudCount = 0;
    private int _humanCount = 0;
    private int _plantText = 0;

    public int waterLevel { get { return _waterLevel; } set { _waterLevel = value; waterText.text = "water " + _waterLevel; } }
    public int animalCount = 0;
    public int birdCount = 0;
    public int fishCount = 0;
    public int cloudCount { get { return _cloudCount; } set { _cloudCount = value; cloudText.text = "cloud " + _cloudCount; } }
    public int humanCount = 0;
    public int plantCount = 0;
}