using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartButton : MonoBehaviour
{
    public bool player1Ready = false;
    public bool player2Ready = false;

    public void PlayerPress(int id)
    {
        if (id == 1)
        {
            player1Ready = true;
        }

        if (id == 2)
        {
            player2Ready = true;
        }

        if (player1Ready && player2Ready)
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("GameScene");
        }
    }
}
