/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_parse.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/23 18:33:56 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/10/18 15:15:16 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_get_camera(int *fd, t_rt *rt)
{
	char	*line;

	line = NULL;
	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	if (ft_strcmp(line, "camera:") != 0)
		ft_error(2);
	while (ft_strcmp(line, "#") != 0)
	{
		free(line);
		if (get_next_line(*fd, &line) == -1)
			ft_error(1);
		if (ft_strcmp(line, "position:") == 0)
			ft_get_coord(&rt->eye.pos, fd);
		else if (ft_strcmp(line, "orientation:") == 0)
			ft_get_rotation(&rt->eye.rot, fd);
		else if (ft_strcmp(line, "translation:") == 0)
			ft_translation(&rt->eye.pos, fd);
		else if (line[0] != '#' && line[1] != '#')
			ft_error(2);
	}
	free(line);
	// if (rt->eye.pos.set == 0 || rt->eye.rot.set == 0)
	// 	ft_error(2);
	rt->eye.rot.y *= -1;
}

int		ft_get_object_data(int *fd, t_object *obj, int id, char *line)
{
	obj->type = id;
	while (ft_strcmp(line, "#") != 0)
	{
		free(line);
		if (get_next_line(*fd, &line) == -1)
			ft_error(1);
		if (ft_strcmp(line, "position:") == 0)
			ft_get_coord(&obj->pos, fd);
		else if (ft_strcmp(line, "orientation:") == 0)
			ft_get_rotation(&obj->rot, fd);
		else if (ft_strcmp(line, "dimension:") == 0)
			ft_get_size(&obj->size, fd);
		else if (ft_strcmp(line, "color:") == 0)
			ft_get_color(&obj->color, fd);
		else if (ft_strcmp(line, "translation:") == 0)
			ft_translation(&obj->pos, fd);
		else if (line[0] != '#' && line[1] != '#')
			ft_error(2);
	}
	free(line);
	// if (obj->pos.set == 0 || (obj->size.set == 0 && obj->type != PLANE))
	// 	ft_error(2);
	return (1);
}

int		ft_get_light_data(int *fd, t_rt *rt, int j)
{
	char	*line;

	line = NULL;
	while (ft_strcmp(line, "#") != 0)
	{
		free(line);
		if (get_next_line(*fd, &line) == -1)
			ft_error(1);
		else if (ft_strcmp(line, "position:") == 0)
			ft_get_coord(&rt->lights[j].pos, fd);
		else if (ft_strcmp(line, "intensity:") == 0)
			ft_get_intensity(&rt->lights[j].intensity, fd);
		else if (ft_strcmp(line, "translation:") == 0)
			ft_translation(&rt->lights[j].pos, fd);
	}
	free(line);
	// if (rt->lights[j].pos.set == 0)
	// 	ft_error(2);
	return (1);
}

void	ft_get_objects(int *fd, t_rt *rt)
{
	char	*line;
	int		id;
	int		i;
	int		j;

	j = 0;
	i = 0;
	id = 0;
	line = NULL;
	while (ft_strcmp(line, "end") != 0)
	{
		free(line);
		if (get_next_line(*fd, &line) == -1)
			ft_error(2);
		else if ((id = ft_objectid(line)) != -1)
		{
			if (id == 4)
				j += ft_get_light_data(fd, rt, j);
			else
				i += ft_get_object_data(fd, &rt->objects[i], id, NULL);
		}
		else if (line[0] != '#' && ft_strcmp(line, "end"))
			ft_error(2);
	}
	free(line);
}

void	ft_parse(char *file, t_data *data)
{
	char	*line;
	int		fd;

	line = NULL;
	if ((fd = open(file, O_RDONLY)) == -1)
		ft_error(1);
	if (get_next_line(fd, &line) == -1)
		ft_error(1);
	if (ft_strcmp(line, "scene:") != 0)
		ft_error(2);
	free(line);
	ft_get_camera(&fd, &data->rt);
	ft_init_objects(file, &data->rt, -1, -1);
	ft_get_objects(&fd, &data->rt);
	close(fd);
	ft_default_value(data->rt.objects, &data->rt);
}
