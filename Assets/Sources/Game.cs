using FMOD.Studio;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    public SO_SystemData dataModel;
    private List<Timer> _timer = new List<Timer>();

    private Timer _gameTimer = null;

    public Player player1;
    public Player player2;

    public TMP_Text gameClock;

    private bool _gameRunning;
    public float pourcent = 0.5f;

    private EventInstance mainMusic = default(EventInstance);

    public EventInstance humanLifeInstance = default(EventInstance);
    public EventInstance animalLifeInstance = default(EventInstance);
    public EventInstance plantLifeInstance = default(EventInstance);
    public EventInstance watterLifeInstance = default(EventInstance);
    public EventInstance cloudLifeInstance = default(EventInstance);

    public int maxPlant = 0;
    public int maxCloud = 0;
    public int maxWatter = 0;
    public int maxHuman = 0;
    public int maxAnimal = 0;
    public List<GameObject> versions;
    private void Awake()
    {
        
    }
    // Start is called before the first frame update
    void Start()
    {
        StartGame();
    }

    public void StartGame ()
    {
        versions[Random.Range(0, versions.Count)].SetActive(true);

        player1.Setup(this);
        player2.Setup(this);

        player1.playerScore.sun = true;
        player2.playerScore.sun = false;
        
        _gameTimer = CreateTimer(dataModel.gameDuration);

        _gameTimer.stoped += () => 
        {
            _gameRunning = false;
            mainMusic.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
            FMODUnity.RuntimeManager.PlayOneShot("event:/Interface/victory");
        };

        _gameTimer.Start();
        _gameRunning = true;

        FindObjectOfType<GameFeedback>().Setup(this);

        mainMusic = FMODUnity.RuntimeManager.CreateInstance("event:/Music/music-ingame");
        mainMusic.start();

        maxAnimal = 36 * 2;
        maxHuman = 12 * 2;
        maxPlant = dataModel.plantsMaximumPlants * 2;
        maxWatter = dataModel.waterMaximumLevels * 2;
        maxCloud = dataModel.atmosphereMaximumClouds * 2;

        humanLifeInstance = FMODUnity.RuntimeManager.CreateInstance("event:/Environmental loops/human life");
        animalLifeInstance = FMODUnity.RuntimeManager.CreateInstance("event:/Environmental loops/animal life");
        cloudLifeInstance = FMODUnity.RuntimeManager.CreateInstance("event:/Environmental loops/atmosphere");
        plantLifeInstance = FMODUnity.RuntimeManager.CreateInstance("event:/Environmental loops/plantlife");
        watterLifeInstance = FMODUnity.RuntimeManager.CreateInstance("event:/Environmental loops/water");

        humanLifeInstance.start();
        animalLifeInstance.start();
        cloudLifeInstance.start();
        plantLifeInstance.start();
        watterLifeInstance.start();

        player1.playerScore.plantsChangeEvent += Player1PlantsChange;
        player1.playerScore.cloudsChangeEvent += Player1CloudsChange;
        player2.playerScore.plantsChangeEvent += Player2PlantsChange;
        player2.playerScore.cloudsChangeEvent += Player2CloudsChange;

    }

    public void Player1PlantsChange(bool change)
    {
        if (change)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/plants-add");
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/good-stinger");
        }
        else
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/plants-delete");
        }
    }

    public void Player2PlantsChange(bool change)
    {
        if (change)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/plants-add");
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/bad-stinger");
        }
        else
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/plants-delete");
        }
    }

    public void Player1CloudsChange(bool change)
    {
        if (change)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/clouds-add");
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/good-stinger");
        }
        else
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/clouds-delete");
        }
    }

    public void Player2CloudsChange(bool change)
    {
        if (change)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/clouds-add");
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/evil-stinger");
        }
        else
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/clouds-delete");
        }
    }
    // Update is called once per frame
    void Update()
    {
        if (_gameRunning == false)
            return;

        gameClock.text = _gameTimer.currentTime;

        for (int i = 0; i < _timer.Count; i++)
        {
            _timer[i].Update(Time.deltaTime);
        }

        player1.UpdateInput();
        player2.UpdateInput();
        player1.UpdateScore();
        player2.UpdateScore();

        //0 full player 1
        //0.5 full equal
        //1 full player 2

        float score1 = player1.playerScore.score;
        float score2 = player2.playerScore.score;
        float total = score1 + score2;

        if (score1 > score2)
        {
            //how much from 0 to 0.5
            pourcent = Mathf.Lerp(0.5f, 0f, score1 / total);
        }
        else
        {
            pourcent = Mathf.Lerp(0.5f, 1f, score2 / total);
        }

        mainMusic.setParameterByName("goodvsbad", pourcent);

        humanLifeInstance.setParameterByName("intensity", (player1.playerScore.humanCount + player2.playerScore.humanCount) / maxHuman);
        animalLifeInstance.setParameterByName("intensity", (player1.playerScore.totalAnimalsCount + player2.playerScore.totalAnimalsCount) / maxAnimal);
        cloudLifeInstance.setParameterByName("intensity", (player1.playerScore.cloudCount + player2.playerScore.cloudCount) / maxCloud);
        plantLifeInstance.setParameterByName("intensity", (player1.playerScore.plantCount + player2.playerScore.plantCount) / maxPlant);
        watterLifeInstance.setParameterByName("intensity", (player1.playerScore.waterLevel + player2.playerScore.waterLevel) / maxWatter);
    }

    public Timer CreateTimer(float duration, float tick = 0f, bool loop = false)
    {
        Timer timer = new Timer(duration, tick, loop);
        _timer.Add(timer);
        return timer;
    }
}
