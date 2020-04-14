using ACNHCompanion.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class Home : TabbedPage
    {
        public FishViewModel FishTab { get; set; }
        public BugsViewModel BugsTab { get; set; }

        public Home()
        {
            InitializeComponent();

            FishTab = new FishViewModel();
            BugsTab = new BugsViewModel();

            NavigationPage fishPage = new NavigationPage(new CrittersPage());
            fishPage.IconImageSource = "fish_anchovy.png";
            fishPage.Title = "Fish";
            fishPage.BindingContext = FishTab;

            NavigationPage bugsPage = new NavigationPage(new CrittersPage());
            bugsPage.IconImageSource = "bug_Bell_cricket.png";
            bugsPage.Title = "Bugs";
            bugsPage.BindingContext = BugsTab;

            Children.Add(fishPage);
            Children.Add(bugsPage);
        }
    }
}