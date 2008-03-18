MODULE = SWISH::3		PACKAGE = SWISH::3::Config	

PROTOTYPES: enable

swish_Config *
new(CLASS)
    char* CLASS;
    
    CODE:
        RETVAL = swish_init_config();
        RETVAL->ref_cnt++;
        RETVAL->stash = sp_Stash_new();
        
    OUTPUT:
        RETVAL


        
void
set_default(self)
    swish_Config *self
    
    CODE:
        swish_config_set_default(self);
        

# accessors/mutators
void
_set_or_get(self, ...)
    swish_Config *self;
ALIAS:
    set_properties          = 1
    get_properties          = 2
    set_metanames           = 3
    get_metanames           = 4
    set_mimes               = 5
    get_mimes               = 6
    set_parsers             = 7
    get_parsers             = 8
    set_aliases             = 9
    get_aliases             = 10
    set_index               = 11
    get_index               = 12
    set_misc                = 13
    get_misc                = 14
PREINIT:
    SV* RETVAL;
PPCODE:
{
    
    //warn("number of items %d for ix %d", items, ix);
    
    START_SET_OR_GET_SWITCH

    // set properties
    case 1:  croak("TODO");
             break;
             
    // get properties
    case 2:  RETVAL = sp_bless_ptr( PROPERTY_HASH_CLASS, (IV)self->properties );
             break;
             
    // set metanames
    case 3:  croak("TODO");
             break;
             
    // get metanames
    case 4:  RETVAL = sp_bless_ptr( METANAME_HASH_CLASS, (IV)self->metanames );
             break;
           
    // set mimes  
    case 5:  croak("TODO");
             break;
    
    // get mimes
    case 6:  RETVAL = sp_bless_ptr( XML2_HASH_CLASS, (IV)self->mimes );
             break;
             
    // set parsers
    case 7:  croak("TODO");
             break;
           
    // get parsers  
    case 8:  RETVAL = sp_bless_ptr( XML2_HASH_CLASS, (IV)self->parsers );
             break;
    
    // set aliases
    case 9:  croak("TODO");
             break;
             
    // get aliases
    case 10: RETVAL = sp_bless_ptr( XML2_HASH_CLASS, (IV)self->tag_aliases );
             break;
    
    // set index
    case 11: croak("TODO");
             break;
             
    // get index
    case 12: RETVAL = sp_bless_ptr( XML2_HASH_CLASS, (IV)self->index );
             break;
    
    // set misc
    case 13: croak("TODO");
             break;
             
    // get misc
    case 14: RETVAL = sp_bless_ptr( XML2_HASH_CLASS, (IV)self->misc );
             break;
        
    END_SET_OR_GET_SWITCH
}
 
void
debug(self)
    swish_Config* self
    
    CODE:
        swish_debug_config(self);
        



void
add(self, conf_file)
    swish_Config* self
	char *	conf_file
    
    CODE:
        swish_add_config((xmlChar*)conf_file, self);
      
      
void
delete(self, key)
    swish_Config* self
    char* key
    
    CODE:
        warn("delete() not yet implemented\n");
        

void
DESTROY(self)
    swish_Config* self;
    
    CODE:
        self->ref_cnt--;
               
        if (SWISH_DEBUG) {
            warn("DESTROYing swish_Config object %s  [%d] [ref_cnt = %d]", 
                SvPV(ST(0), PL_na), self, self->ref_cnt);
        }

        if (self->ref_cnt < 1) {
            
          sp_Stash_destroy( self->stash );
          //SWISH_WARN("set config stash to NULL");
          self->stash = NULL;
          swish_free_config( self );
          
        }
        

        