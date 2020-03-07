using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Game : MonoBehaviour
{
    private List<Timer> _timer = new List<Timer>();

    public float duration = 0f;

    private Timer _gameTimer = null;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void StartGame ()
    {
        _gameTimer = new Timer(duration);
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < _timer.Count; i++)
        {
            _timer[i].Update(Time.deltaTime);
        }
    }
}
