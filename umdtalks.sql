CREATE TABLE uw_Umdtalks_lists(uw_id int8 NOT NULL, uw_title text NOT NULL, 
                                uw_details text NOT NULL, 
                                uw_kind text NOT NULL, 
                                uw_details_filter text NOT NULL, 
                                uw_image_id int8 NOT NULL, 
                                uw_created_at timestamp NOT NULL, 
                                uw_updated_at timestamp NOT NULL,
 PRIMARY KEY (uw_id)
  
 );
 
 CREATE SEQUENCE uw_Umdtalks_listSeq;
  
  CREATE TABLE uw_Umdtalks_talks(uw_id int8 NOT NULL, uw_title text NOT NULL, 
                                  uw_abstract text NOT NULL, 
                                  uw_special_message text NOT NULL, 
                                  uw_abstract_filtered text NOT NULL, 
                                  uw_start_time timestamp NOT NULL, 
                                  uw_end_time timestamp NOT NULL, 
                                  uw_speaker_name text NOT NULL, 
                                  uw_speaker_id int8 NOT NULL, 
                                  uw_series_id int8 NOT NULL, 
                                  uw_venue_id int8 NOT NULL, 
                                  uw_created_at timestamp NOT NULL, 
                                  uw_updated_at timestamp NOT NULL, 
                                  uw_organiser_id int8 NOT NULL, 
                                  uw_image_id int8 NOT NULL,
   PRIMARY KEY (uw_id)
    
   );
   
   CREATE SEQUENCE uw_Umdtalks_talkSeq;
    
    CREATE TABLE uw_Umdtalks_users(uw_id int8 NOT NULL, uw_email text NOT NULL, 
                                    uw_alias text NOT NULL, 
                                    uw_password text NOT NULL, 
                                    uw_affiliation text NOT NULL, 
                                    uw_administrator int8 NOT NULL, 
                                    uw_last_login timestamp NOT NULL, 
                                    uw_image_id int8 NOT NULL, 
                                    uw_created_at timestamp NOT NULL, 
                                    uw_updated_at timestamp NOT NULL, 
                                    uw_session_crumble int8 NOT NULL,
     PRIMARY KEY (uw_id)
      
     );
     
     CREATE SEQUENCE uw_Umdtalks_userSeq;
      
      