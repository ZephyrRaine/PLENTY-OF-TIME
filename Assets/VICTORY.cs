using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
public class VICTORY : MonoBehaviour
{
    public TMP_Text winner;
    // Start is called before the first frame update
    void Start()
    {
        winner.text = FindObjectOfType<VictoryFuck>().WINNER.ToString();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("FireJ1") || Input.GetButtonDown("FireJ2"))
        {
            SceneManager.LoadSceneAsync("GameScene");
            Destroy(this);
        }
    }
}
