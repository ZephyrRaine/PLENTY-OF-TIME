using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{    // Start is called before the first frame update

    public int playerId = 0;
    public Player opponent = null;
    public List<Power> powers = new List<Power>();
    public PlayerScore playerScore = null;
    public Transform playerCursor = null;
    public World world = null;

    private int playerFocus = 0;
    private int powerFocus = 0;
    private int optionFocus = 0;

    private int powerCount = 0;

    public KeyCode left = default(KeyCode);
    public KeyCode right = default(KeyCode);
    public KeyCode up = default(KeyCode);
    public KeyCode down = default(KeyCode);
    public KeyCode jump = default(KeyCode);
    public KeyCode action = default(KeyCode);

    private Game _game;

    public void Setup(Game game)
    {
        _game = game;
        
        powers.AddRange(transform.GetComponentsInChildren<Power>());

        foreach(Power power in powers)
        {
            power.Setup(game);
        }

        powerCount = powers.Count;
        playerFocus = playerId;
    }

    // Update is called once per frame
    public void UpdateInput()
    {
        Keyboard();   
    }

    public void Keyboard ()
    {
        if (Input.GetKeyDown(left))
        {
            if (optionFocus > 0)
                optionFocus = 0;
        }
        else if (Input.GetKeyDown(right))
        {
            if (optionFocus < 1)
                optionFocus = 1;
        }
        else if (Input.GetKeyDown(up))
        {
            powerFocus--;

            if (powerFocus < 0)
                powerFocus = powerCount - 1;
        }
        else if (Input.GetKeyDown(down))
        {
            powerFocus++;

            if (powerFocus >= powerCount)
                powerFocus = 0;
        }
        else if (Input.GetKeyDown(jump))
        {
            if (playerFocus == playerId)
                playerFocus = opponent.playerId;
            else
                playerFocus = playerId;
        }
        else if (Input.GetKeyDown(action))
        {
            if (playerFocus == playerId)
            {
                powers[powerFocus].Launch(this, this, optionFocus);
            }
            else
            {
                opponent.powers[powerFocus].Launch(this, opponent, optionFocus);
            }
        }

        if (playerFocus == playerId)
        {
            if (optionFocus == 0)
                playerCursor.position = powers[powerFocus].optionOne.playerAnchor.transform.position;
            else
                playerCursor.position = powers[powerFocus].optionTwo.playerAnchor.transform.position;

        }
        else
        {
            if (optionFocus == 0)
                playerCursor.position = opponent.powers[powerFocus].optionOne.opponentAnchor.transform.position;
            else
                playerCursor.position = opponent.powers[powerFocus].optionTwo.opponentAnchor.transform.position;

        }
    }
}
