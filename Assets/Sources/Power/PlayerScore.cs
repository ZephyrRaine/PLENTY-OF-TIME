using UnityEngine;
using UnityEngine.UI;

public class PlayerScore : MonoBehaviour
{
    public Text waterText = null;
    public Text animalText = null;
    public Text cloudText = null;
    public Text humanText = null;
    public Text sunText = null;
    public Text plantText = null;


    public Image lightImage = null;
    public Text scoreText = null;

    private int _waterLevel = 0;
    private int _animalCount = 0;
    private int _cloudCount = 0;
    private int _humanCount = 0;
    private int _plantCount = 0;

    private bool _sun = false;
    private bool _lightOff = false;
    private int _score = 0;

    public int waterLevel { get { return _waterLevel; } set { _waterLevel = value; waterText.text = "water " + _waterLevel; } }
    public int animalCount { get { return _animalCount; } set {  _animalCount = value; animalText.text = "animal " + _animalCount; } }
    public int cloudCount { get { return _cloudCount; } set { _cloudCount = value; cloudText.text = "cloud " + _cloudCount; } }
    public int humanCount { get { return _humanCount; } set { _humanCount = value; humanText.text = "human " + _humanCount; } }
    public int plantCount { get { return _plantCount; } set { _plantCount = value; plantText.text = "plant " + _plantCount; } }
    public bool sun { get { return _sun; } set { _sun = value; sunText.text = _sun?"SUN":"MOON"; } }
    public bool lightOff { get { return _lightOff; } set { _lightOff = value; lightImage.enabled = value; }}

    public int score { get { return _score; } set { _score = value; scoreText.text = "score " + _score; } }


}