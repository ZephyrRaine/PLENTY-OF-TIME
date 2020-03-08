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

    public ObjectFeedback objectsAnimalP1;
    public ObjectFeedback objectsAnimalsP2;
    public ObjectFeedback objectsHumansP1;
    public ObjectFeedback objectsHumansP2;
    public ObjectFeedback objectsCloudsP1;
    public ObjectFeedback objectsCloudsP2;
    public ObjectFeedback objectsPlantsP1;
    public ObjectFeedback objectsPlantsP2;

    public void Setup(Game _g)
    {
        _game = _g;
        _game.player1.animalsTimer.started += ()=>{iconAnimalPlayer1.ToggleFeedback(true);};
        _game.player1.animalsTimer.ticked += () => { iconAnimalPlayer1.Tick(); objectsAnimalP1?.PopObject(); };
        _game.player1.animalsTimer.stoped += ()=> {iconAnimalPlayer1.ToggleFeedback(false);};

        _game.player1.humansTimer.started +=  ()=>{iconHumansPlayer1.ToggleFeedback(true);};
        _game.player1.humansTimer.ticked +=  ()=> { iconHumansPlayer1.Tick(); objectsHumansP1?.PopObject(); objectsAnimalP1?.RemoveObject();  };
        _game.player1.humansTimer.stoped +=  ()=>{iconHumansPlayer1.ToggleFeedback(false);};

        _game.player2.animalsTimer.started +=  ()=>{iconAnimalPlayer2.ToggleFeedback(true);};
        _game.player2.animalsTimer.ticked += () => { iconAnimalPlayer2.Tick(); objectsAnimalsP2?.PopObject(); };
        _game.player2.animalsTimer.stoped +=  ()=>{iconAnimalPlayer2.ToggleFeedback(false);};
        
        _game.player2.humansTimer.started +=  ()=>{iconHumansPlayer2.ToggleFeedback(true);};
        _game.player2.humansTimer.ticked += () => { iconHumansPlayer2.Tick(); objectsHumansP2?.PopObject(); objectsAnimalsP2?.RemoveObject();  };
        _game.player2.humansTimer.stoped +=  ()=>{iconHumansPlayer2.ToggleFeedback(false);};

        feedbackMoonSun.SetLeft(_g.player1.playerScore.sun);
        _game.player1.sunTimer.started += feedbackMoonSun.ToggleAnimation;
        _game.player2.sunTimer.started += feedbackMoonSun.ToggleAnimation;

        _game.player1.playerScore.plantsChangeEvent += (x) => { if (x) objectsPlantsP1.PopObject(); else objectsPlantsP1.RemoveObject(); };
        _game.player1.playerScore.cloudsChangeEvent += (x) => { if (x) objectsCloudsP1.PopObject(); else objectsCloudsP1.RemoveObject(); };
        _game.player2.playerScore.plantsChangeEvent += (x) => { if (x) objectsPlantsP2.PopObject(); else objectsPlantsP2.RemoveObject(); };
        _game.player2.playerScore.cloudsChangeEvent += (x) => { if (x) objectsCloudsP2.PopObject(); else objectsCloudsP2.RemoveObject(); };
    }

    // Update is called once per frame
    void UpdateFeedback()
    {
        
    }
}
