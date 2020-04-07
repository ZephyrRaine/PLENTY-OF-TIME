using TMPro;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class VICTORY : MonoBehaviour
{
    public TMP_Text winner;
    // Start is called before the first frame update
    void Start()
    {
        winner.text = FindObjectOfType<VictoryFuck>().WINNER.ToString();

        var myAction = new InputAction(binding: "/*/<button>");
        myAction.performed += (action) => { myAction.Disable(); myAction.Dispose(); Reload(); };
        myAction.Enable();
    }

    void  Reload ()
    {
        SceneManager.LoadSceneAsync("GameScene");
        Destroy(this);
    }

    // Update is called once per frame
    void Update()
    {
        //
    }
}
