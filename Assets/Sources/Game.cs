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

    public GameObject player1Prefab;
    public GameObject player2Prefab;

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

        _gameTimer.stoped += () => { _gameRunning = false; };
        _gameTimer.Start();
        _gameRunning = true;


        GameObject.Instantiate(player1Prefab, Vector3.zero, Quaternion.identity);
        GameObject.Instantiate(player2Prefab, Vector3.zero, Quaternion.identity);

        /*
        Keyboard keyboard = Keyboard.current;

        Keyboard keyboard = Keyboard.current;
        
        var inputP1 = PlayerInput.Instantiate(player1Prefab, controlScheme: "WASD", pairWithDevice: Keyboard.current);
        inputP1.name = "P1";
        
        var inputP2 = PlayerInput.Instantiate(player2Prefab, controlScheme: "Arrows", pairWithDevice: Keyboard.current);
        inputP2.name = "P2";
        */

        GetComponent<GameFeedback>().Setup(this);
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
    }

    public Timer CreateTimer(float duration, float tick = 0f, bool loop = false)
    {
        Timer timer = new Timer(duration, tick, loop);
        _timer.Add(timer);
        return timer;
    }
}
