using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VictoryFuck : MonoBehaviour
{
    public int WINNER
    {
    set
        {
            _winner = value;
        }
    get
        {
            Destroy(gameObject);
            return _winner;
        }
    }
    int _winner;

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);

    }

}
