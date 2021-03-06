package vibhakticompute;
use feature_filter;
use shakti_tree_api;
use Exporter qw(import);

our @EXPORT = qw(vibhakticompute);

sub ComputeTAM
{
	my $sent=@_[0];
        my $keep = $_[1];

	my @uns_VG_nodes = get_nodes(3,"VGF",$sent);	#get all the VG nodes
	my @VGINF_nodes = get_nodes(3,"VGINF",$sent);	#get all the VG nodes
	my @VGNF_nodes = get_nodes(3,"VGNF",$sent);	#get all the VG nodes
	my @VGNN_nodes = get_nodes(3,"VGNN",$sent);	#get all the VG nodes
	
	#push VGINF,VGNF,VGNN nodes to uns_VG_nodes. Thus we have single list containing all the VG nodes.
	foreach (@VGINF_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	foreach (@VGNF_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	foreach (@VGNN_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	
	my @remove;
	my @VG_nodes = sort {$a <=> $b}(@uns_VG_nodes);	#sorting list in ascending order
	foreach $node (@VG_nodes)
	{
		my @leaves = get_leaves_child($node,$sent); #gets all the leaves of the the VG node
		my $parent = $node;
		my $head = 0;
		my $final_tam_aux = "";
		my $neg = "";
		$fs_array_head = "";	
		$verb_leaf_present = 0;
		my $flag=0;
		my @final_tam;
		my @_leaf;
		my $position="";

		$f4=get_field($node,4,$sent); #gets fs of the node
		my $string_fs = read_FS($f4, $sent);
		my @head_value = get_values("head", $string_fs, $sent);#gets head value of the node

		#checks for verb leaf, if present sets verb_leaf_present=1
		foreach $leaf (@leaves)
		{
			$leaf_tag = get_field($leaf, 3,$sent);#gets postag of leaf
			if($leaf_tag =~ /^V/)
			{
				$verb_leaf_present = 1;
			}
		}
		
 		
		foreach $leaf (@leaves)
		{
			$leaf_tag = get_field($leaf, 3,$sent);#gets postag of leaf
			$leaf_lex = get_field($leaf, 2,$sent);#gets lexical item of leaf
			if($leaf_tag =~/^V/ and $head == 0)	
			{

				$head = 1;
				$node_head = $leaf;
				$fs = get_field($leaf, 4,$sent);#gets feature structure
				$fs_array = read_FS($fs,$sent);
				$fs_array_head = $fs_array;
				@tam = get_values("vib", $fs_array,$sent);
				my @name_value= get_values("name",$fs_array,$sent); #gets value of name attribute 
				if($head_value[0] eq $name_value[0])
				{
					$num=$leaf-$node; #gives position of the leaf with respect to the nodei
					
					# modifies the value of vpos(position) in a chunk
					
					if($position ne "")
					{$position=$position."_"."tam$num";}
					if($position eq "")
					{$position="tam$num";}
				}
		#storing tam values
				if($tam[0] ne "")
				{
					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".$tam[0];
					}
					else
					{
						$final_tam_aux = $tam[0];
					}
		#store all the tam of all interpretation in $final_tam
				}
				else
				{
					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".0;
					}
					else
					{
						$final_tam_aux = 0;
					}
				}
			}
			elsif($leaf_tag=~/^VAUX/ or $leaf_tag=~/PSP/ or $leaf_tag=~/NST/) #identifying whether a vibhakti or not.
			{
				$flag=1;
		          	#modifying the value of vpos(position)
				if($position ne "")
				{
					$num=$leaf-$node;
					$position=$position."_".$num;
				}
				else
				{
					$position=$leaf-$node;
				}
				


				my $word1=get_field($leaf,2,$sent); #gets the word(lex)
#print "LEAF TAG--$leaf_tag--$word1\n";
				push(@remove,$leaf);
				$fs = get_field($leaf, 4,$sent);
				$fs_array = read_FS($fs,$sent);
				@tam = get_values("vib", $fs_array); #gets value of vib attribute 
				@lex = get_values("lex", $fs_array); #gets lexical item(root)
				push(@_leaf,$leaf);
				my $root = $lex[0];
				my $tam_t = "";
				#line 137 to 162 modifies tam feature of fs.
				
				if($tam[0] ne "" and $tam[0] ne "`" and $tam[0] ne "0" and $tam[0] ne $root)
				{
					$tam_t = $tam[0];
					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".$root."+".$tam_t;
					}
					else
					{
						$final_tam_aux = $root."+".$tam_t;
					}
				}
				else
				{
					$tam_t = "0";

					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".$root;
					}
					else
					{
						$final_tam_aux = $root;
					}
				}
			}
			elsif($leaf_tag eq 'NEG' and $verb_leaf_present == 1)
			{
=cut
				if($position ne "")
				{
					$num=$leaf-$node;
					$position=$position."_"."NEG$num";
				}
				if($position eq "")
				{
					$num=$leaf-$node;
					$position="NEG$num";
				}
				$neg = get_field($leaf, 2,$sent);
				
				push(@remove,$leaf);
				$flag=1;
				$fs = get_field($leaf, 4,$sent);
				$fs_array = read_FS($fs,$sent);
				@tam = get_values("vib", $fs_array);
				@lex = get_values("lex", $fs_array);
				push(@_leaf,$leaf);
				my $root = $lex[0];
				my $tam_t = "";
				if($tam[0] ne "" and $tam[0] ne "`" and $tam[0] ne "0" and $tam[0] ne $root)
				{
					$tam_t = $tam[0];
					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".$root."+".$tam_t;
					}
					else
					{
						$final_tam_aux = $root."+".$tam_t;
					}
				}
				else
				{
					$tam_t = "0";
					if($final_tam_aux ne "")
					{
						$final_tam_aux = $final_tam_aux."_".$root;

					}
					else
					{
						$final_tam_aux = $root;
					}
				}
=cut
			}


		}
		
		$fs_head = get_field($parent, 4,$sent);
		$fs_head_array = read_FS($fs_head,$sent);
		my @num,@gen,@per;
#print "-->",$#_leaf,"\n";	
		if($#_leaf>0)	
		{
			my $fs1 = get_field($_leaf[-1], 4,$sent);
			my $fs2 = get_field($_leaf[-2], 4,$sent);

			$fs_array1=read_FS($fs1,$sent);
			$fs_array2=read_FS($fs2,$sent);
			@num = get_values("num", $fs_array1,$sent);
			@per = get_values("per", $fs_array1,$sent);
			@gen = get_values("gen", $fs_array2,$sent);
		}
		if($#_leaf==0)	
		{
			my $fs1 = get_field($_leaf[-1], 4,$sent);
			my $pos1 = get_field($_leaf[-1], 3,$sent);
			if($pos1 eq "VAUX" or $pos1 eq "PSP")
			{
			$fs_array1=read_FS($fs1,$sent);
			@num = get_values("num", $fs_array1,$sent);
			@per = get_values("per", $fs_array1,$sent);
			}
		}
		$tam_new[0] = $final_tam_aux;
		update_attr_val_2("vib", \@tam_new, $fs_head_array->[0],$sent);
		#print "@num[0]--@per[0]--@gen[0]\n";
		if(@gen[0] ne "")
		{
			update_attr_val_2("gen", \@gen, $fs_head_array->[0],$sent);
		}
		if(@num[0] ne "")
		{	
			update_attr_val_2("num", \@num, $fs_head_array->[0],$sent);
		}
		if(@per[0] ne "")
		{
			update_attr_val_2("per", \@per, $fs_head_array->[0],$sent);
		}

		if($verb_leaf_present == 1 and $flag==1)
		{
			$string_head = make_string($fs_head_array,$sent);
			my ($x,$y)=split(/>/,$string_head);
			my $new_head_fs=$x." vpos=\"$position\">";
			modify_field($parent, 4, $new_head_fs,$sent);
		}
		delete @num[0..$#remove];
		delete @per[0..$#remove];
		delete @gen[0..$#remove];
	}
        if (not defined $keep) {
            my @sort_remove=sort{$a <=> $b} @remove;
            my $delete=0;
            foreach (@sort_remove)
            {
                delete_node($_-$delete,$sent);
                $delete++;
            }
            delete @remove[0..$#remove];
            delete @sort_remove[0..$#remove];
        }

	#print "after vib comp--\n";
	#print_tree();
}

#use GDBM_File;
#the module prunes multiple feature structure (NN, NNP, PRP at present), it also removes the parsarg node in the NP and adds it to its noun fs.
#$compute_vibhakti;
sub ComputeVibhakti
{
	my $sent=@_[0];
        my $keep = $_[1];

	#my $delete;	#keeps count of all the deleted node, helps in locating node obtained before deletion.

	#get all the noun nodes in the tree, the noun will be case marked '1' if a vibhakti is present, else case is '0'

	#my @all_leaves = get_leaves();
	#read(@_[0]);	
	my @all_children_NP =get_nodes(3,"NP",$sent); #gets all the NP nodes
	my @all_children_RBP =get_nodes(3,"RBP",$sent); #gets all the RBP nodes
        my @all_children = (@all_children_NP , @all_children_RBP); #contains all the NP and RBP nodes
        my @all_children = sort { $a <=> $b } @all_children;
	
	foreach $node(@all_children)
	{

		my @node_leaves=get_leaves_child($node,$sent); #gets leaf nodes of NP or RBP node
		
 	               
		$position="";
		$nhead=0;
		$f4=get_field($node,4,$sent); # gets feature structure
		my $string_fs = read_FS($f4, $sent);
		
		#gets head and vibhakti values 
		
		my @head_value = get_values("head", $string_fs, $sent); 
		my @vibh_value=get_values("vib", $string_fs, $sent);
		$vibh_chunk=$vibh_value[0]; 
		#iterates through each leaf node and gets postag, word, fs
		
		foreach $NP_child(@node_leaves)
		{
			my $pos = get_field($NP_child,3,$sent);
			my $word = get_field($NP_child,2,$sent);
			my $fs = get_field($NP_child,4,$sent);
			my $str_fs=read_FS($fs,$sent);
			my @name_value=get_values("name",$str_fs,$sent); 
			if($pos eq "NN" or $pos eq "NNP" or $pos eq "PRP")
			{
				$nhead=1;
				$flag=0;
				$prev_RB=0;
				$flag_NN=1
			}
			if($pos eq "RB")
			{
				$flag=1;
				$prev_RB = 1;
				$flag_NN=0
			        
			}
			
			if($head_value[0] eq $name_value[0])
			{
				$num=$NP_child-$node; #gives position of the leaf with respect to the node
				
				# modifies the value of vpos(position) in a chunk

				if($position ne "")
				{$position=$position."_"."vib$num";} 
				if($position eq "")
				{$position="vib$num";}

			}
			
			
			#Adds the RP vibhakti to vpos
			
			if($pos eq "RP")
			{      
				if($position ne "")
				{
					$position=$position."_"."RP";
				}
				else
				{
					next;
				}
			}
			
			
			if($pos eq "PSP" or $pos eq "NST" and $nhead==1)
			{       
				#Adds position of vibhakti in vpos(position) value

				if($position ne "")
				{
					$num=$NP_child-$node;
					$position=$position."_".$num;
				}
				
				else
				{
					$position=$NP_child-$node;
				}
				my $val_fs=get_field($NP_child, 4,$sent);

				$FSreference = read_FS($val_fs,$sent); #reads feature structure of the leaf
				my @cur_vibhakti = get_values("lex",$FSreference); #fetches the lexical value of vibhakti
				my @cur_vib_vib = get_values("vib",$FSreference); 
				
				#adds the lexical value of vibhakti to vibh_chunk

				if($vibh_chunk ne "")
				{
					$vibh_chunk=$vibh_chunk . "_" . $cur_vibhakti[0];
				}
				else
				{
					$vibh_chunk="0_".$cur_vibhakti[0];
				}
					push(@remove,$NP_child);

			}
			
		}
		if($vibh_chunk)
			{
				my @vibh_chunk_arr=();
				push @vibh_chunk_arr,$vibh_chunk; #pushes the value of vibh_chunk in vibh_chunk_arr 

				my $head_node=get_field($node,4,$sent); 
				my $FSreference1 = read_FS($head_node,$sent); #gets FS value
				update_attr_val("vib", \@vibh_chunk_arr,$FSreference1,$sent); #updates value of attribute vib
				
				# Modifies the value of fs by adding new attribute vpos that will be in output.
				
				my $string=make_string($FSreference1,$sent);
				my ($x,$y)=split(/>/,$string);
				my $new_head_fs=$x." vpos=\"$position\">"; 
				modify_field($node,4,$new_head_fs,$sent); 

				undef $head_word;
				undef $new_string;
			}
	}
        if (not defined $keep) {
            #Deletes the leaves containing vibhakti.
            $delete=0;
            foreach (@remove)
            {
                delete_node($_-$delete,$sent);
                $delete++;
            }
            delete @remove[0..$#remove];
        }
}

sub vibhakticompute {
    my ($input, $keep, $output) = @_;

    read_story($input);

    $numbody = get_bodycount();
    for(my($bodynum)=1;$bodynum<=$numbody;$bodynum++)
    {

        $body = get_body($bodynum,$body);

        # count the number of paragraphs in the story
        my($numpara) = get_paracount($body);

        #print stderr "paras : $numpara\n";

        # iterate through paragraphs in the story
        for(my($i)=1;$i<=$numpara;$i++)
        {

            my($para);
            # read paragraph
            $para = get_para($i);


            # count the number of sentences in this paragraph
            my($numsent) = get_sentcount($para);
            # iterate through sentences in the paragraph
            for(my($j)=1;$j<=$numsent;$j++)
            {

                # read the sentence which is in ssf format
                my($sent) = get_sent($para,$j);

                #copy vibhakti info
                ComputeVibhakti($sent, $keep);

                #compute tam
                ComputeTAM($sent, $keep);
            }
        }
    }

    if($output eq "" )
    {
        printstory();
    }

    else
    {
        printstory_file("$output");
    }
}

1;

