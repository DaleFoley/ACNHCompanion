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