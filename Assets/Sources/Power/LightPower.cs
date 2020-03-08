public class LightPower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        if (target.playerScore.lightOff == false)
        {
            target.playerScore.lightOff = true;

            FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/lightoff");

            if (source.playerId == 1)
            {
                FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/good-stinger");
            }
            else
            {
                FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/evil-stinger");
            }
        }
    }
}