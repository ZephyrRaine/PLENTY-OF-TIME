using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public abstract class Power : MonoBehaviour
{
    //Data
    public float cooldownDuration;
    public float powerDuration;
    public int ammount = -1;

    public bool available;
    public bool running;

    private int _launchCount = 0;

    public UnityEvent selected;

    public PowerToggle optionOne;
    public PowerToggle optionTwo;

    protected Game _game;

    public virtual void Setup(Game game)
    {
        _game = game;
    }

    public void UpdateCooldown (float deltaTime)
    {

    }   



    public virtual void Launch(Player source, Player target, int option)
    {

    }
}
