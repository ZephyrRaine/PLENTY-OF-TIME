using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFeedback : MonoBehaviour
{
    // Start is called before the first frame update
    Game _game;

    public FeedbackIcon iconAnimalPlayer1;
    public FeedbackIcon iconAnimalPlayer2;
    public FeedbackIcon iconHumansPlayer1;
    public FeedbackIcon iconHumansPlayer2;
    
    public FeedbackMoonSun feedbackMoonSun;

    public void Setup(Game _g)
    {
        _game = _g;
        _game.player1.animalsTimer.started += ()=>{iconAnimalPlayer1.ToggleFeedback(true);};
        _game.player1.animalsTimer.stoped += ()=> {iconAnimalPlayer1.ToggleFeedback(false);};
        _game.player1.humansTimer.started +=  ()=>{iconHumansPlayer1.ToggleFeedback(true);};
        _game.player1.humansTimer.stoped +=  ()=>{iconHumansPlayer1.ToggleFeedback(false);};

        _game.player2.animalsTimer.started +=  ()=>{iconAnimalPlayer2.ToggleFeedback(true);};
        _game.player2.animalsTimer.stoped +=  ()=>{iconAnimalPlayer2.ToggleFeedback(false);};
        _game.player2.humansTimer.started +=  ()=>{iconHumansPlayer2.ToggleFeedback(true);};
        _game.player2.humansTimer.stoped +=  ()=>{iconHumansPlayer2.ToggleFeedback(false);};

        feedbackMoonSun.SetLeft(_g.player1.playerScore.sun);
        _game.player1.sunTimer.started += feedbackMoonSun.ToggleAnimation;
        _game.player2.sunTimer.started += feedbackMoonSun.ToggleAnimation;
    }

    // Update is called once per frame
    void UpdateFeedback()
    {
        
    }
}
