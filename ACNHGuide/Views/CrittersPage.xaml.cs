using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHGuide.Models;
using ACNHGuide.Views;
using ACNHGuide.ViewModels;

namespace ACNHGuide.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CrittersPage : ContentPage
    {
        //private CrittersViewModel _crittersViewModel;
        public CrittersPage()
        {
            InitializeComponent();

            //this._crittersViewModel = new CrittersViewModel();
            //this.BindingContext = this._crittersViewModel.Critters;
        }
    }
}