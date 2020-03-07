public class AtmospherePower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        if (option == 0 && (target.playerScore.cloudCount < _game.dataModel.atmosphereMaximumClouds))
        {
            base.Launch(source, target, option);
            target.playerScore.cloudCount++;
        }
        else if (option == 1 && target.playerScore.cloudCount > 0)
        {
            base.Launch(source, target, option);
            target.playerScore.cloudCount--;
        }
    }
}
