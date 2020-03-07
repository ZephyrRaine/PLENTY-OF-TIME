public class PlantPower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        if (option == 0 && (target.playerScore.plantCount < _game.dataModel.plantsMaximumPlants))
        {
            base.Launch(source, target, option);
            target.playerScore.plantCount++;
        }
        else if (option == 1 && target.playerScore.plantCount > 0)
        {
            base.Launch(source, target, option);
            target.playerScore.plantCount--;
        }
    }
}
