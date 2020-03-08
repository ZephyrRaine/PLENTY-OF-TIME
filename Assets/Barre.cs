using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
public class Barre : MonoBehaviour
{
    public Image leftBarre;
    public Image rightBarre;

    public Color leftColorWin;
    public Color rightColorWin;
    public Color colorLoose;

    Game game;
    private void Start()
    {
        game = FindObjectOfType<Game>();
    }
    public void SetWinning(float winning)
    {
        leftBarre.color = Color.Lerp(colorLoose, leftColorWin, 1 - winning);
        rightBarre.color = Color.Lerp(colorLoose, rightColorWin, winning);
    }

    // Update is called once per frame
    void Update()
    {
        SetWinning(game.pourcent);
    }
}
