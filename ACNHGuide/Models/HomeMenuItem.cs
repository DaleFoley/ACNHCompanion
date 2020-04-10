using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHGuide.Models
{
    public enum MenuItemType
    {
        Browse,
        About,
        Critters
    }
    public class HomeMenuItem
    {
        public MenuItemType Id { get; set; }

        public string Title { get; set; }
    }
}
