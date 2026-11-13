{ ... } :
    {
        personal =
            {
                agenix = ./age.key ;
                description = "Chester Checker" ;
                email = "chester@checker.com" ;
                name = "checker" ;
                password = "chester" ;
                temporary =
                    {
                        ssh =
                            {
                                identity = ./temporary/id_rsa ;
                                known-hosts = ./temporary/known-hosts ;
                            } ;
                    } ;
                wifi =
                    {
                    } ;
            } ;
    }