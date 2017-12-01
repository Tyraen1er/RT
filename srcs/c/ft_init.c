/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_init.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/23 15:07:34 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/10/27 21:16:22 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_init_data(t_data *data)
{
	t_rt	*rt;
	int		i;

	i = 0;
	rt = &data->rt;
	while (++i < rt->nb_obj)
		if (i < rt->nb_obj)
			rt->objects[i].rot = ft_norm_vector(rt->objects[i].rot);
	i = -1;
	while (++i < MAX_RAND)
		data->rand[i] = (double)rand() / (double)RAND_MAX;
	ft_calc_dir_vec(&data->rt.eye, data->rt.m);
}

void	ft_init_objs(t_rt *rt, int o, int l)
{
	// if (!(rt->objects = (t_object *)malloc(rt->nb_obj * sizeof(t_object))))
	// 	ft_error(3);
	// if (!(rt->lights = (t_light *)malloc(rt->nb_light * sizeof(t_light))))
	// 	ft_error(3);
	// ft_bzero(rt->objects, rt->nb_obj * sizeof(rt->objects[0]));
	// ft_bzero(rt->lights, rt->nb_light * sizeof(rt->lights[0]));
	while (++o < rt->nb_obj)
		rt->objects[o].color.c = -1;
	while (++l < rt->nb_light)
		rt->lights[l].intensity = -1;
}

void	ft_init_objects(char *file, t_rt *rt, int o, int l)
{
	char	*line;
	int		fd;
	int		i;

	i = 0;
	line = NULL;
	if ((fd = open(file, O_RDONLY)) == -1)
		ft_error(1);
	while (get_next_line(fd, &line))
	{
		if (ft_objectid(line) < 4 && ft_objectid(line) > -1)
			rt->nb_obj++;
		else if (ft_objectid(line) == 4)
			rt->nb_light++;
		else if (ft_strcmp(line, "#") == 0)
			i++;
		free(line);
	}
	close(fd);
	if (i - 1 < rt->nb_light + rt->nb_obj)
		ft_error(2);
	ft_init_objs(rt, o, l);
}