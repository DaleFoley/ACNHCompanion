using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using ACNHCompanion.ViewModels;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CrittersPage : ContentPage
    {
        public CrittersPage()
        {
            InitializeComponent();
            //BindingContext = new CrittersViewModel();
        }

        void OnImageNameTapped(object sender, EventArgs args)
        {
            try
            {
                DisplayAlert("Test", "Test", "Cancel");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}