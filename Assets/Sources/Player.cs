using FMOD.Studio;
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

    public Timer sunTimer;
    public Timer moonTimer;
    public Timer animalsTimer;
    public Timer humansTimer;
    public Timer lightTimer;

    public EventInstance lightOffInstance = default(EventInstance);

    public void Setup(Game game)
    {
        _game = game;

        lightOffInstance = FMODUnity.RuntimeManager.CreateInstance("event:/SFX/lightoff");

        powers.AddRange(transform.GetComponentsInChildren<Power>());

        foreach (Power power in powers)
        {
            power.Setup(game);
        }

        powerCount = powers.Count;
        playerFocus = playerId;

        sunTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.waterIncreaseTime);
        moonTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.waterDecreaseTime);
        animalsTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.animalsIncreaseTime);
        humansTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.humansIncreaseTime);
        lightTimer = _game.CreateTimer(_game.dataModel.lightOffTime);

        lightTimer.stoped += () => { playerScore.lightOff = false; lightOffInstance.stop(FMOD.Studio.STOP_MODE.IMMEDIATE); };


        sunTimer.ticked += ()=>
        {
            playerScore.waterLevel = Mathf.Min(_game.dataModel.waterMaximumLevels,
                playerScore.waterLevel + _game.dataModel.waterIncreaseValue);
        };

        moonTimer.ticked += ()=>
        {
            playerScore.waterLevel = Mathf.Max(0,
                playerScore.waterLevel - _game.dataModel.waterDecreaseValue);
        };

        animalsTimer.ticked += ()=>
        {
                playerScore.animalCount += _game.dataModel.animalsIncreaseValue; 
                playerScore.totalAnimalsCount += _game.dataModel.animalsIncreaseValue;
                playerScore.score += _game.dataModel.animalsScoreIncrease;        
        };
        humansTimer.ticked += ()=>
        {
            playerScore.humanCount += _game.dataModel.humansIncreaseValue; 
            playerScore.score += _game.dataModel.humansScoreIncrease; 
            playerScore.animalCount -= _game.dataModel.humansRequiredAnimals;    
        };


    }

    // Update is called once per frame
    public void UpdateInput()
    {
        Keyboard();   
    }

    private void UpdateLight ()
    {
        if(lightTimer.running == false && playerScore.lightOff == true)
        {
            lightOffInstance.start();
            lightTimer.Start();
        }
    }

    private void UpdateSun()
    {
        if(!sunTimer.running)
        {
            if(playerScore.sun)
            {
                sunTimer.Start();
            }
        }
        else
        {
            if(!playerScore.sun)
            {
                sunTimer.Stop();
            }
        }
    }


    private void UpdateMoon()
    {
        if(!moonTimer.running)
        {
            if(!playerScore.sun)
            {
                moonTimer.Start();
            }
        }
        else
        {
            if(playerScore.sun)
            {
                moonTimer.Stop();
            }
        }
    }

    private void UpdateAnimals()
    {
        if(!animalsTimer.running)
        {
            if(playerScore.lightOff == false && playerScore.plantCount >= _game.dataModel.animalsRequiredPlants)
            {
                animalsTimer.Start();
            }
        }
        else
        {
            if(playerScore.lightOff || playerScore.plantCount < _game.dataModel.animalsRequiredPlants)
            {
                animalsTimer.Stop();
            }
        }
    }

    private void UpdateHumans()
    {
        bool condition = playerScore.cloudCount >= _game.dataModel.humansRequiredClouds && playerScore.waterLevel >= _game.dataModel.humansRequiredWater && playerScore.animalCount >= _game.dataModel.humansRequiredAnimals;

        if(!humansTimer.running)
        {
            if(condition)
            {
                humansTimer.Start();
            }
        }
        else
        {
            if(!condition)
            {
                humansTimer.Stop();
            }
        }
    }
    public void UpdateScore()
    {
        UpdateLight();
        UpdateSun();
        UpdateMoon();
        UpdateAnimals();
        UpdateHumans();
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
                if (optionFocus == 0)
                {
                    powers[powerFocus].Launch(this, this, powers[powerFocus].optionOne.option);
                }
                else
                {
                    powers[powerFocus].Launch(this, this, powers[powerFocus].optionTwo.option);
                }                    
            }
            else
            {
                if (optionFocus == 0)
                {
                    opponent.powers[powerFocus].Launch(this, opponent, opponent.powers[powerFocus].optionOne.option);
                }
                else
                {
                    opponent.powers[powerFocus].Launch(this, opponent, opponent.powers[powerFocus].optionTwo.option);
                }
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
