using ACNHCompanion;
using ACNHCompanion.Views;
using Android.Content;
using Android.Support.Design.Widget;
using Android.Views;
using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;
using Xamarin.Forms.Platform.Android;
using Xamarin.Forms.Platform.Android.AppCompat;

[assembly: ExportRenderer(typeof(Home), typeof(MyTabbedPageRenderer))]
namespace ACNHCompanion
{
    public class MyTabbedPageRenderer : TabbedPageRenderer
    {
        public MyTabbedPageRenderer(Context context) : base(context)
        {

        }

        //Reference: LandLu - https://forums.xamarin.com/discussion/comment/376630#Comment_376630
        protected override void OnElementChanged(ElementChangedEventArgs<TabbedPage> e)
        {
            base.OnElementChanged(e);

            if (e.OldElement == null && e.NewElement != null)
            {
                for (int i = 0; i <= this.ViewGroup.ChildCount - 1; i++)
                {
                    var childView = this.ViewGroup.GetChildAt(i);
                    if (childView is ViewGroup viewGroup)
                    {
                        for (int j = 0; j <= viewGroup.ChildCount - 1; j++)
                        {
                            var childRelativeLayoutView = viewGroup.GetChildAt(j);
                            if (childRelativeLayoutView is BottomNavigationView)
                            {
                                ((BottomNavigationView)childRelativeLayoutView).ItemIconTintList = null;
                            }
                        }
                    }
                }
            }
        }
    }
}
