
//
//  DiaryEntity.m
//
//
//  Created by Arpan Dixit on 25/06/15.
//
//

#import "DiaryEntity.h"
#import "DiaryFields.h"
#import "EYL_AppData.h"
#import "WhatIateTodayModal.h"


@implementation DiaryEntity

@dynamic name;
@dynamic fields;
@dynamic visibility;
@dynamic cameInVariableName;
@dynamic leftAtVariableName;


+ (instancetype) createEYL_DiaryEntityInContext:(NSManagedObjectContext *) context
{

    return [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntity"
                                         inManagedObjectContext:context];
}

+ (instancetype) createEYL_DiaryEntityContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forEntityName : (NSString *) entityName
{
    NSLog(@"dictionary is %@", dictionary);
    DiaryEntity *diaryobj;
    NSError *_savingError = nil;
    diaryobj = [DiaryEntity createEYL_DiaryEntityInContext:context];
    EYL_AppData *app = [EYL_AppData sharedEYL_AppData];
    
    if ([entityName isEqualToString:@"registry"])
    {
        NSArray *theArray = [dictionary valueForKey:@"registry"];
        
        NSPredicate *newPredic=[NSPredicate predicateWithFormat:@"SELF.key==%@",@"came_in_at"];
        NSArray *cameInArray=[theArray filteredArrayUsingPredicate:newPredic];
        
        NSDictionary *dic=[cameInArray lastObject];
        
        
        diaryobj.cameInVariableName=[dic objectForKey:@"value"];
        
        NSPredicate *newPredicate=[NSPredicate predicateWithFormat:@"SELF.key==%@",@"left_at"];
        NSArray *leftAtArray=[theArray filteredArrayUsingPredicate:newPredicate];
        
        NSDictionary *dict=[leftAtArray lastObject];
        diaryobj.leftAtVariableName=[dict objectForKey:@"value"];
        
//        key = "came_in_at";
//        value = "In At";
//    },
//    {
//        key = "left_at";
//        value = "Left at";
//    }
       
        diaryobj.visibility=YES;
        
    }
    if([entityName isEqualToString:@"additionalnotes"])
    {
        diaryobj.visibility=YES;

    }
    if([entityName isEqualToString:@"observationEyfs"]||[entityName isEqualToString:@"observationfields"])
    {
        diaryobj.visibility=YES;
    }
    if ([entityName isEqualToString:@"nappies"])
    {
        NSPredicate *predicate;
        NSArray *array=[NSArray new];
        
         NSArray *theArray = [dictionary valueForKey:@"nappies"];
        for (NSDictionary *dic in theArray)
        {
            if ([[dic valueForKey:@"key"] isEqualToString:@"nappies_visible"])
            {
                diaryobj.visibility=[[dic objectForKey:@"value"] integerValue];
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_nappies"])
            {
                
                [diaryobj setAge_group:[dic objectForKey:@"value"]];
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_nappies_start"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_nappies"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_nappies"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_start:[dic valueForKey:@"value"]];
                        
                    }
                }
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_nappies_end"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_nappies"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_nappies"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_end:[dic valueForKey:@"value"]];
                        
                    }
                }
            }

        }
   
    }
    if ([entityName isEqualToString:@"i_had_my_bottle"])
    {
        NSPredicate *predicate;
        NSArray *array=[NSArray new];
        NSArray *theArray = [dictionary valueForKey:@"i_had_my_bottle"];
        for (NSDictionary *dic in theArray)
        {
            if ([[dic valueForKey:@"key"] isEqualToString:@"i_had_my_bottle_visible"])
            {
                 diaryobj.visibility=[[dic objectForKey:@"value"] integerValue];
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_i_had_my_bottle"])
            {
                
                [diaryobj setAge_group:[dic objectForKey:@"value"]];
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_i_had_my_bottle_start"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_i_had_my_bottle"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_i_had_my_bottle"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_start:[dic valueForKey:@"value"]];
                        
                    }
                }
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_i_had_my_bottle_end"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_i_had_my_bottle"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_i_had_my_bottle"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_end:[dic valueForKey:@"value"]];
                        
                    }
                }
            }
        }

    }
    if ([entityName isEqualToString:@"toileting_today_1"])
    {
        NSPredicate *predicate;
        NSArray *array=[NSArray new];
        NSArray *theArray = [dictionary valueForKey:@"toileting_today_1"];
        for (NSDictionary *dic in theArray)
        {
            if ([[dic valueForKey:@"key"] isEqualToString:@"toileting_today_visible"])
            {
                 diaryobj.visibility=[[dic objectForKey:@"value"] integerValue];
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_toileting_today"])
            {
                
                [diaryobj setAge_group:[dic objectForKey:@"value"]];
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_toileting_today_start"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_toileting_today"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_toileting_today"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_start:[dic valueForKey:@"value"]];
                        
                    }
                }
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_toileting_today_end"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_toileting_today"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_toileting_today"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_end:[dic valueForKey:@"value"]];
                        
                    }
                }
            }
        }

    }
    if ([entityName isEqualToString:@"sleep_times"])
    {
        NSPredicate *predicate;
        NSArray *array=[NSArray new];
        
        NSArray *theArray = [dictionary valueForKey:@"sleep_times"];
        for (NSDictionary *dic in theArray)
        {
            if ([[dic valueForKey:@"key"] isEqualToString:@"sleep_times_visible"])
            {
                diaryobj.visibility=[[dic objectForKey:@"value"] integerValue];
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_sleep_times"])
            {
                
                [diaryobj setAge_group:[dic objectForKey:@"value"]];
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_sleep_times_start"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_sleep_times"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_sleep_times"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_start:[dic valueForKey:@"value"]];
                        
                    }
                }
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_sleep_times_end"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_sleep_times"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_sleep_times"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_end:[dic valueForKey:@"value"]];
                        
                    }
                }
            }
        }

    }
    
    
    if ([entityName isEqualToString:@"what_i_ate_today"])
    {
        //EYL_AppData *app = [EYL_AppData sharedEYL_AppData];

        
        NSArray *theArray = [dictionary valueForKey:@"what_i_ate_today"];
        NSPredicate *predicate;
        NSArray *array=[NSArray new];
        

        
        for (NSDictionary *dic in theArray)
        {
            WhatIateTodayModal *obj = [[WhatIateTodayModal alloc] init];
            
            
            if ([[dic valueForKey:@"key"] isEqualToString:@"what_i_ate_today_visible"])
            {
                [obj setWhat_i_ate_today_visible:[[dic objectForKey:@"value"] integerValue]];
                  diaryobj.visibility=[[dic objectForKey:@"value"] integerValue];
                
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_what_i_ate_today"])
            {

                [diaryobj setAge_group:[dic objectForKey:@"value"]];
            
                
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_what_i_ate_today_start"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_what_i_ate_today"];
                array=[theArray filteredArrayUsingPredicate:predicate];
            
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_what_i_ate_today"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_start:[dic valueForKey:@"value"]];

                    }
                }
                
            
            }
            if ([[dic valueForKey:@"key"] isEqualToString:@"age_group_what_i_ate_today_end"])
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"age_group_what_i_ate_today"];
                array=[theArray filteredArrayUsingPredicate:predicate];
                
                if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"age_group_what_i_ate_today"])
                {
                    if([[[array firstObject] valueForKey:@"value"]isEqualToString:@"Between"])
                    {
                        [diaryobj setAge_group_end:[dic valueForKey:@"value"]];
                        
                    }
                }
            }
           
            
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"breakfast_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"breakfast_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
                    if ([[dic valueForKey:@"key"] isEqualToString:@"breakfast"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"breakfast"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"breakfast"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
            }
            }
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"snack_am_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"snack_am_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
             if ([[dic valueForKey:@"key"] isEqualToString:@"snack_am"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"snack_am"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"snack_am"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
                }
            }
            
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"lunch_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"lunch_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
            if ([[dic valueForKey:@"key"] isEqualToString:@"lunch"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"lunch"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"lunch"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
            }
            }
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"pudding_am_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"pudding_am_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
             if ([[dic valueForKey:@"key"] isEqualToString:@"pudding_am"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"pudding_am"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"pudding_am"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
            }
            }
      
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"pudding_pm_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"pudding_pm_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
             if ([[dic valueForKey:@"key"] isEqualToString:@"pudding_pm"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"pudding_pm"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"pudding_pm"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
                }
            }
            
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"snack_pm_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"snack_pm_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
            if ([[dic valueForKey:@"key"] isEqualToString:@"snack_pm"])
            {
                [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                [obj setStrName:[dic valueForKey:@"value"]];
                [obj setStrKey:@"snack_pm"];
                [app saveObject:[dic valueForKey:@"value"] forKey:@"snack_pm"];
                [app.array_WhatIateToday addObject:obj];
                obj=nil;
            }
                }
            }
            
            predicate=[NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"tea_visible"];
            array=[theArray filteredArrayUsingPredicate:predicate];
            
            if([[[array firstObject] valueForKey:@"key"] isEqualToString:@"tea_visible"])
            {
                if([[[array firstObject] valueForKey:@"value"] integerValue]==1)
                {
                    if ([[dic valueForKey:@"key"] isEqualToString:@"tea"])
                    {
                        [app.array_WhatIateTodayStatic addObject:[dic valueForKey:@"key"]];
                        [obj setStrName:[dic valueForKey:@"value"]];
                        [obj setStrKey:@"tea"];
                        [app saveObject:[dic valueForKey:@"value"] forKey:@"tea"];
                        [app.array_WhatIateToday addObject:obj];
                        obj=nil;
                    }
                }
                
            }
        }
        NSLog(@"%@", app.array_WhatIateTodayStatic);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:app.array_WhatIateTodayStatic forKey:@"array_WhatIateTodayStatic"];
        [userDefaults synchronize];
    }

    if(diaryobj == nil)
    { //Couldn't create the data base entry
        NSLog(@"EYL_DiaryEntity : Couldn't create Ecat in context %s", "");
    }
    diaryobj.name = entityName;
    NSMutableSet *set = [NSMutableSet set];
    if([[dictionary objectForKey:entityName] isKindOfClass:[NSString class]])
    {
       

    }
    else
    {
    for (int i=0; i < [[dictionary valueForKey:entityName] count]; i++)
    {
        DiaryFields *field=[DiaryFields  createEYL_DiaryFieldsInContext:context];
        field.keyName = [[[dictionary valueForKey:entityName] objectAtIndex:i] valueForKey:@"key"];
        field.keyValue = [NSString stringWithFormat:@"%@", [[[dictionary valueForKey:entityName] objectAtIndex:i] valueForKey:@"value"]];
        [set addObject:field];
        field = nil;
    }
    }
    diaryobj.fields=set;
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return diaryobj;
    }

    return nil;
}


+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"DiaryEntity" inManagedObjectContext:context]];
    NSError *fetchError=nil;
    NSArray *results=[context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
    return results;
    return nil;
}
+(BOOL) deleteInContext:(NSManagedObjectContext *)a_context
{
    NSError *_savingError = nil;
    NSArray *observation = [DiaryEntity fetchAllRecords:a_context];
    
    if (observation.count > 0) {
            
        for (DiaryEntity *diary in observation) {
            [a_context deleteObject:diary];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Deleted now");
        
        return true;
    } else
    {
        //Saved failed
                return false;
    }
}


@end
