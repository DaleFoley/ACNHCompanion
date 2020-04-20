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
    public partial class SortFilterContentView : ContentView
    {
        private SortFilterViewModel _sortFilterViewModel;

        public SortFilterContentView()
        {
            InitializeComponent();

            _sortFilterViewModel = new SortFilterViewModel();
            BindingContext = _sortFilterViewModel;

        }

        private void ImageButton_Clicked(object sender, EventArgs e)
        {
            this.IsVisible = false;
            this.InputTransparent = true;
        }
    }
}