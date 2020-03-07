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

    private Timer _sunTimer;
    private Timer _moonTimer;
    private Timer _animalsTimer;
    private Timer _humansTimer;
    private Timer _lightTimer;

    public void Setup(Game game)
    {
        _game = game;

        powers.AddRange(transform.GetComponentsInChildren<Power>());

        foreach (Power power in powers)
        {
            power.Setup(game);
        }

        powerCount = powers.Count;
        playerFocus = playerId;

        _sunTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.waterIncreaseTime);
        _moonTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.waterDecreaseTime);
        _animalsTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.animalsIncreaseTime);
        _humansTimer = _game.CreateTimer(_game.dataModel.gameDuration, _game.dataModel.humansIncreaseTime);
        _lightTimer = _game.CreateTimer(_game.dataModel.lightOffTime);

        _lightTimer.stoped += () => { playerScore.lightOff = false; };
        _sunTimer.ticked += ()=>{playerScore.waterLevel += _game.dataModel.waterIncreaseValue; };
        _moonTimer.ticked += ()=>{playerScore.waterLevel -= _game.dataModel.waterDecreaseValue; };
        _animalsTimer.ticked += ()=>
        {
                playerScore.animalCount += _game.dataModel.animalsIncreaseValue; 
                playerScore.score += _game.dataModel.animalsScoreIncrease;        
        };
        _humansTimer.ticked += ()=>
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
        if(_lightTimer.running == false && playerScore.lightOff == true)
        {
            _lightTimer.Start();
        }
    }

    private void UpdateSun()
    {
        if(!_sunTimer.running)
        {
            if(playerScore.sun)
            {
                _sunTimer.Start();
            }
        }
        else
        {
            if(!playerScore.sun)
            {
                _sunTimer.Stop();
            }
        }
    }


    private void UpdateMoon()
    {
        if(!_moonTimer.running)
        {
            if(!playerScore.sun)
            {
                _moonTimer.Start();
            }
        }
        else
        {
            if(playerScore.sun)
            {
                _moonTimer.Stop();
            }
        }
    }

    private void UpdateAnimals()
    {
        if(!_animalsTimer.running)
        {
            if(playerScore.lightOff && playerScore.plantCount >= _game.dataModel.animalsRequiredPlants)
            {
                _animalsTimer.Start();
            }
        }
        else
        {
            if(!playerScore.lightOff || playerScore.plantCount < _game.dataModel.animalsRequiredPlants)
            {
                _animalsTimer.Stop();
            }
        }
    }

    private void UpdateHumans()
    {
        bool condition = playerScore.cloudCount >= _game.dataModel.humansRequiredClouds && playerScore.waterLevel >= _game.dataModel.humansRequiredWater && playerScore.animalCount >= _game.dataModel.humansRequiredAnimals;

        if(!_humansTimer.running)
        {
            if(condition)
            {
                _humansTimer.Start();
            }
        }
        else
        {
            if(!condition)
            {
                _humansTimer.Stop();
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
