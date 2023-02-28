
clear
concept_tab = readtable('./results/AWS_concept_rank.csv');
concept_tab = concept_tab(round(concept_tab.score,2)>0,:);


take = 50;
subtab_head = head(concept_tab,take);
subtab_tail = flip(tail(concept_tab,take));
fp = fopen(sprintf('./results/Latex_concept_score_rank_top_bottom_%d.tex',take), 'w');
for(jjj = 1:take)
	fprintf(fp, '%s & %s & %d & %1.2f & %1.2f & %s & %s & %d & %1.2f & %1.2f\\\\\n', ...
			subtab_head.concept_String{jjj}, subtab_head.entity_String{jjj}, subtab_head.paper_number(jjj), subtab_head.paper_avg_deg(jjj), subtab_head.score(jjj),...
			subtab_tail.concept_String{jjj}, subtab_head.entity_String{jjj}, subtab_tail.paper_number(jjj), subtab_tail.paper_avg_deg(jjj), subtab_tail.score(jjj));
end
fprintf(fp, '\\\\\\hline\n');
fclose(fp);






