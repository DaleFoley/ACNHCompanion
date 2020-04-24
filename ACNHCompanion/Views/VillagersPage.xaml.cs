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
    public partial class VillagersPage : ContentPage
    {
        public VillagersPage(VillagersViewModel villagerViewModel)
        {
            InitializeComponent();

            BindingContext = villagerViewModel;
        }
    }
}