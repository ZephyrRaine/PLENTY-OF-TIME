using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Game : MonoBehaviour
{
    public SO_SystemData dataModel;
    private List<Timer> _timer = new List<Timer>();

    public float duration = 0f;

    private Timer _gameTimer = null;

    public Player player1;
    public Player player2;



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
        
        _gameTimer = new Timer(duration);
    }

    // Update is called once per frame
    void Update()
    {
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
