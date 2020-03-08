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

    private EventInstance mainMusic = default(EventInstance);

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

        GetComponent<GameFeedback>().Setup(this);

        mainMusic = FMODUnity.RuntimeManager.CreateInstance("event:/Music/music-ingame");
        mainMusic.start();
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
        float pourcent = 0.5f;

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
    }

    public Timer CreateTimer(float duration, float tick = 0f, bool loop = false)
    {
        Timer timer = new Timer(duration, tick, loop);
        _timer.Add(timer);
        return timer;
    }
}
