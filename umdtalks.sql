CREATE TABLE uw_Umdtalks_lists(uw_id int8 NOT NULL, uw_title text NOT NULL, 
                                uw_details text NOT NULL, 
                                uw_image_id int8 NOT NULL, 
                                uw_created_at timestamp NOT NULL, 
                                uw_updated_at timestamp NOT NULL,
 PRIMARY KEY (uw_id)
  
 );
 
 CREATE SEQUENCE uw_Umdtalks_listSeq;
  
  CREATE TABLE uw_Umdtalks_lists_lists(uw_parent_id int8 NOT NULL, 
                                        uw_child_id int8 NOT NULL
   );
   
   CREATE TABLE uw_Umdtalks_talks(uw_id int8 NOT NULL, uw_title text NOT NULL, 
                                   uw_abstract text NOT NULL, 
                                   uw_start_time timestamp NOT NULL, 
                                   uw_end_time timestamp NOT NULL, 
                                   uw_speaker_name text NOT NULL, 
                                   uw_venue text NOT NULL, 
                                   uw_created_at timestamp NOT NULL, 
                                   uw_updated_at timestamp NOT NULL, 
                                   uw_image_id int8 NOT NULL,
    PRIMARY KEY (uw_id)
     
    );
    
    CREATE SEQUENCE uw_Umdtalks_talkSeq;
     
     CREATE TABLE uw_Umdtalks_lists_talks(uw_parent_id int8 NOT NULL, 
                                           uw_talk_id int8 NOT NULL
      );
      
      CREATE TABLE uw_Umdtalks_users(uw_id int8 NOT NULL, 
                                      uw_email text NOT NULL, 
                                      uw_alias text NOT NULL, 
                                      uw_password text NOT NULL, 
                                      uw_affiliation text NOT NULL, 
                                      uw_last_login timestamp NOT NULL, 
                                      uw_image_id int8 NOT NULL, 
                                      uw_created_at timestamp NOT NULL, 
                                      uw_updated_at timestamp NOT NULL, 
                                      uw_session_crumb text NOT NULL,
       PRIMARY KEY (uw_id)
        
       );
       
       CREATE SEQUENCE uw_Umdtalks_userSeq;
        
        CREATE TABLE uw_Umdtalks_list_owners(uw_owner_id int8 NOT NULL, 
                                              uw_list_id int8 NOT NULL
         );
         
         CREATE TABLE uw_Umdtalks_talk_owners(uw_owner_id int8 NOT NULL, 
                                               uw_talk_id int8 NOT NULL
          );
          
          